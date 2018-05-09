<p align="center">
  <a href="https://bootstapemail.com">
    <img src="https://bootstrapemail.com/img/icons/logo.png" alt="" width=72 height=72>
  </a>

  <h3 align="center">Bootstrap Email</h3>

  <p align="center">
    If you know Bootstrap, you know Bootstrap Email.
    <br>
    <a href="https://bootstrapemail.com/docs/introduction"><strong>Explore Bootstrap Email docs »</strong></a>
  </p>
</p>

<br>

[![Gem](https://img.shields.io/gem/v/bootstrap-email.svg)](https://rubygems.org/gems/bootstrap-email)
[![Gem](https://img.shields.io/gem/dt/bootstrap-email.svg)](https://rubygems.org/gems/bootstrap-email)

The goal of this project is to build a library that matches the Bootstrap 4 API. It has two parts, a compiler that takes regular HTML with bootstrap classes and compiles it into tables and layout the works in email, and CSS that work with those layouts and inlined to give consistent performance and appearance across email clients.

This project is still under development and looking for contributors willing to help however they can. I'm excited about this <3

## Supported Bootstrap Classes
<small>{color} in these examples is `primary`, `secondary`, `success`, `warning`, `danger`, `light`, and `dark`</small>
- [Alerts](https://bootstrapemail.com/docs/alert): `.alert`, `.alert-{color}`
- [Badges](https://bootstrapemail.com/docs/badge): `.badge`, `.badge-{color}`, `.badge-pill`
- [Buttons](https://bootstrapemail.com/docs/button): `.btn`, `.btn-{color}`, `.btn-outline-{color}`
- [Cards](https://bootstrapemail.com/docs/card): `.card`, `.card-body`
- [Color](https://bootstrapemail.com/docs/color): `.text-{color}`, `.bg-{color}`
- [Containers](https://bootstrapemail.com/docs/container): `.container`, `.container-fluid`
- [Floats](https://bootstrapemail.com/docs/float): `.float-left`, `.float-right`
- [Grid](https://bootstrapemail.com/docs/grid): `.row`, `.col-{1-12}`, `.col-lg-{1-12}`
- [Hrs](https://bootstrapemail.com/docs/hr): `<hr>`
- [Spacing](https://bootstrapemail.com/docs/spacing): `.p{tlbrxy}-{lg-}{0-5}`, `.m{tby}-{lg-}{0-5}`, `.s-{lg-}{0-5}`, `w-{lg-}{25,50,75,100}`, `mx-auto`
- [Tables](https://bootstrapemail.com/docs/table): `.table`, `.table-striped`,`.table-bordered`, `.thead-light`, `.thead-dark`, `.table-{color}`, `.table-dark`
- [Typography](https://bootstrapemail.com/docs/typography): `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`, `<strong>`, `<u>`, `<em>`, `<s>`, `.text-left`, `.text-center`, `.text-right`

## Additional Classes
- [Visibility](https://bootstrapemail.com/docs/visibility): `.d-desktop`, `.d-mobile`

## Email Quirk (for users)
- width and height of images must be set to ensure proper rendering in outlook.
- an anchor tag must have a link in the href (not just a #) for it to properly render a .btn.

<!-- ## Email Quirks (internal notes)
- Line height should always be in px never a number or percentage. https://www.marketingcloud.com/blog/design-tip-of-the-week-css-line-height-property-does-it-work-in-email/
- Padding can only be used inside of a table cell.
- Margin can only be used on divs.
- Font family is reset at the top of every new table.
- Responsive media query for stacking table cells with display block only works on Android in table header `<th>` cells and not table cells `<td>`.
- To make a table width 100% BOTH the table and the td tags must be set to 100%
- Many Outlook versions ignore css that has `important!`.
 -->
