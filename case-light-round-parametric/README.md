# Open-Smartwatch OpenSCAD Files

The case can either use 10mm M2 hex screws, like the other designs, or 12mm M2 hex screws.
The printed straps required 6mm M2 hex screws, like the others.

If the preview in 'watch.scad' is too resource-intensive to work smoothly, set 'strap_radius' in 'strap.scad' to 0!

## Configuration

Settings that apply to all parts of the watch are defined in 'common.scad'.
You can of course modify these options, as well as ones from other files, as needed.

Use 'watch.scad' to either see the parts assembled, or generate an STL file for printing by setting 'view_assembly' to 'false'.

The text on top of the watchface is using the 'Droid Sans' font.
If this is not available on your system, you may want to select a different 'text_font' in 'top.scad' and adjust 'text-size' accordingly.

## Tools

The design files are made with [OpenSCAD](https://openscad.org/).
They have been made with version 2021.01 on Arch Linux.
