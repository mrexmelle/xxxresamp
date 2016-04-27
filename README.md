
[![Build Status](https://travis-ci.org/mrexmelle/xxxresamp.svg?branch=master)](https://travis-ci.org/mrexmelle/xxxresamp)

# Description
xxxresamp is a tool that resamples an image designated for xxxhdpi screen density into images with multiple lower dpi screen densities.

# Installation
Download the source code:

	git clone https://github.com/mrexmelle/xxxresamp

Enter xxxresamp directory

	cd xxxresamp

Compile and install it:
	
	make install
	
This will install the xxxresamp binary into `/usr/local/bin` directory.

# Usage
xxxresamp resamples the **xxxhdpi image file** into multiple image files for lower screen densities. The command should be composed to be like this:

	xxxresamp <xxxhdpi image file>
	
# Example
You can run the example by typing the following command from the project root directory:
	
	xxxresamp data/ic_search.png

