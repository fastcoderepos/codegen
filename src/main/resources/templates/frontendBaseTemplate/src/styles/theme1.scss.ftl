//@import '~@angular/material/theming'; //uncomment for prod
@import './node_modules/@angular/material/_theming.scss'; //for unit test purpose
// Plus imports for other components in your app.

// Include the common styles for Angular Material. We include this here so that you only
// have to load a single css file for Angular Material in your app.
// Be sure that you only ever include this mixin once!
@include mat-core();
//$fc-theme-primary: mat-palette($mat-light-green);
$mat-deep-green:#336a77;
$mat-deep-orange:#e27e4b;
$fc-theme-primary: mat-palette($mat-cyan, 900);
$fc-theme-accent:  mat-palette($mat-amber,800);
//$fc-theme-primary: mat-palette($mat-deep-purple,500);
//$fc-theme-accent:  mat-palette($mat-teal, A200, A100, A400);

//$fc-theme-accent: mat-palette(500);
// Define the palettes for your theme using the Material Design palettes available in palette.scss
// (imported above). For each palette, you can optionally specify a default, lighter, and darker
// hue. Available color palettes: https://material.io/design/color/
//$candy-app-primary: mat-palette($mat-indigo);
//$candy-app-primary: mat-palette(500);
//$candy-app-accent:  mat-palette($mat-pink, A200, A100, A400);

// The warn palette is optional (defaults to red).
$fc-theme-warn:    mat-palette($mat-red);

// Create the theme object (a Sass map containing all of the palettes).
$fc-theme: mat-light-theme($fc-theme-primary, $fc-theme-accent, $fc-theme-warn);

// Include theme styles for core and each component used in your app.
// Alternatively, you can import and @include the theme mixins for each component
// that you are using.
@include angular-material-theme($fc-theme);