# Bootstrap Email
### Bootstrap 4 compiler and CSS for responsive emails

The goal of this project is to build a library that matches the Bootstrap 4 API. It has two parts, a compiler that takes regular HTML with bootstrap classes and compiles it into tables and layout the works in email, and CSS that work with those layouts and inlined to give consistent performance and appearance across email clients.

This project is still under development and looking for contributors willing to help however they can. I'm excited about this <3

## Supported Bootstrap Classes
<small>(color) in these examples is `primary`, `secondary`, `success`, `warning`, `danger`, `light`, and `dark`</small>
- [Alerts](https://getbootstrap.com/docs/4.0/components/alerts/): `.alert`, `.alert-{color}`
- [Badges](https://getbootstrap.com/docs/4.0/components/badge/): `.badge`, `.badge-{color}`, `.badge-pill`
- [Buttons](https://getbootstrap.com/docs/4.0/components/buttons/): `.btn`, `.btn-{color}`, `.btn-outline-{color}`
- [Cards](https://getbootstrap.com/docs/4.0/components/card/): `.card`, `.card-body`
- [Color](https://getbootstrap.com/docs/4.0/utilities/colors/): `.text-{color}`, `.bg-{color}`
- [Containers](https://getbootstrap.com/docs/4.0/layout/overview/#containers): `.container`, `.container-fluid`
- [Grid](https://getbootstrap.com/docs/4.0/layout/grid/): `.row`, `.col-{1-12}`, `.col-lg-{1-12}`
- Hrs: `<hr>`
- [Spacing](https://getbootstrap.com/docs/4.0/utilities/spacing/): `.m{tlbr}-{0-5}`, `.p{tlbr}-{0-5}`,
- [Tables](https://getbootstrap.com/docs/4.0/content/tables/): `.table`, `.table-striped`, `.thead-default`, `.thead-inverse`, `.table-{color}`, `.table-inverse`
- [Typography](https://getbootstrap.com/docs/4.0/content/typography/): `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`, `<strong>`, `<u>`, `<em>`, `<s>`, `.text-left`, `.text-center`, `.text-right`

## Additional Classes
- Alignment: `.align-left`, `.align-center`, `.align-right`
- Display: `.d-desktop`, `.d-mobile`

## Email Quirks (internal notes)
- Line height should always be in px never a number or percentage. https://www.marketingcloud.com/blog/design-tip-of-the-week-css-line-height-property-does-it-work-in-email/
- The only way to add spacing is padding inside of a table cell.
- Font family is reset at the top of every new table.
- Responsive media query for stacking table cells with display block only works on Android in table header `<th>` cells and not table cells `<td>`.
- To make a table width 100% BOTH the table and the td tags must be set to 100%
- To center align something you must add align on the table and the td for it to work in Yahoo!
