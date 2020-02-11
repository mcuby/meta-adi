# This extension just serves as an example on how one can extend the fpga-manage-util
# to make use of fpga-manager with ADI reference designs. An overlay example is being provided
# for fmcomms5-zcu102. In this example, we completely overwrite the devicetree autogenerated by
# petalinux. Note that, to support other reference designs, is up to the user to provide the
# devicetree overlay.
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://pl-fmcomms5-zcu102-overlay.dtsi"


# Important for the pre-processor
DEVICETREE_PP_FLAGS += " \
		-I${STAGING_KERNEL_DIR}/include \
		"

do_compile_prepend() {
	# this is taken from the fpga-manager-util recipe
	for hdf in ${HDF_LIST}; do
		DTS_FILE=${XSCTH_WS}/${hdf}/pl.dtsi
		if grep -qse "/plugin/;" ${DTS_FILE}; then
			[ ! -e "${WORKDIR}/pl-${hdf}-overlay.dtsi" ] && { \
				bbwarn "No overlay found. Using petalinux autogenerated one..."; continue; }

			# let's overwrite our overlay...
			cp "${WORKDIR}/pl-${hdf}-overlay.dtsi" ${DTS_FILE}
		fi
	done
}