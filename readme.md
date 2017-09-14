# Bootstrap Email
### Bootstrap 4 compiler and CSS for responsive emails

The goal of this project is to build a library that matches the Bootstrap 4 API. It has two parts, a compiler that takes regular HTML with bootstrap classes and compiles it into tables and layout the works in email, and CSS that work with those layouts and inlined to give consistent performance and appearance across email clients.

This project is still under development and looking for contributors willing to help however they can. I'm excited about this <3

## Email Quirks (internal notes)

- Line height should always be in px never a number or percentage. https://www.marketingcloud.com/blog/design-tip-of-the-week-css-line-height-property-does-it-work-in-email/
- The only way to add spacing is padding inside of a table cell.
- Font family is reset at the top of every new table.
- Responsive media query for stacking table cells with display block only works on Android in table header (<th>) cells and not table cells (<td>).
- To make a table width 100% BOTH the table and the td tags must be set to 100%
- To center align something you must add align on the table and the td for it to work in Yahoo!
