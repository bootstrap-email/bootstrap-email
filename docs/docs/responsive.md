---
layout: docs
title:  "Responsive"
---
<h1 class="mt-0">{{ page.title }}</h1>

When you see the
<span class="d-inline-block">
  <a href="/docs/themeable" class="badge m-0 d-flex align-items-center compatability-badge">
    <span class="badge-check">
      <img src="/img/icons/check.svg" />
    </span>
    <span>Responsive</span>
  </a>
</span> badge it means the component has responsive breakpoints for different sized screens. The breakpoint is anything 600px or wider is considered `lg` and anything under 600px is `sm`.

Not everything that is responsive uses these names. For example the `.container`is responsive by default and expands and contracts on different screens.

This is the list of every responsive class:
```scss
.container
.container-fluid

.col-{1-12}
.col-lg-{1-12}

.w-{25,50,75,100}
.w-lg-{25,50,75,100}

.p-{0-5}
.p-lg-{0-5}
.pt-{0-5}
.pt-lg-{0-5}
.pr-{0-5}
.pr-lg-{0-5}
.pb-{0-5}
.pb-lg-{0-5}
.pl-{0-5}
.pl-lg-{0-5}
.px-{0-5}
.px-lg-{0-5}
.py-{0-5}
.py-lg-{0-5}

.mt-{0-5}
.mt-lg-{0-5}
.mb-{0-5}
.mb-lg-{0-5}
.my-{0-5}
.my-lg-{0-5}

.s-{0-5}
.s-lg{0-5}

.d-mobile
.d-desktop
```
