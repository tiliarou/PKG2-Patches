all:
	@mkdir -p dist/atmosphere/kip_patches/fs_patches dist/atmosphere/kip_patches/loader_patches
	@cp fusee/fs_patches/* dist/atmosphere/kip_patches/fs_patches/
	@cp fusee/loader_patches/* dist/atmosphere/kip_patches/loader_patches/
	@cd dist; zip -q -r ../fusee.zip .
	@rm -rf dist
	@mkdir -p dist/bootloader
	@cp hekate/* dist/bootloader/
	@cd dist; zip -q -r ../hekate.zip .
	@rm -rf dist
