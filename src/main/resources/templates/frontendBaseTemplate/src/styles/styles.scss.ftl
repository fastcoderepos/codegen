/* You can add global styles to this file, and also import other style files */
@import "theme1.scss";

@import url("../assets/font.css");

body {
    /* font-family: 'Raleway', sans-serif; */
    font-family: "Futura PT";
    background-color: #eef1f1;

    /* padding-bottom: 20px; */
}

h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6, p, a, span, div {
    font-family: "Futura PT";
}

h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
	font-weight: 500;
}

h4, .h4, h5, .h5, h6, .h6 {
    margin-top: 10px;
    margin-bottom: 10px;
}

html, body {
    height: 100%;
}

body {
    margin: 0;
    font-family: 'Roboto', sans-serif;
}

[hidden] {
    display: none !important;
}

.fc-modal-dialog {
    mat-dialog-container {
        padding: 0;

        //height:  '100%';
        // width: '100%';
        //  max-width: none !important;
        //  max-height: none !important;
   
    }
}

.snackbar-background {
    background-color: #8bc34a;
}

.subnav .mat-radio-label {
    font-size: 16px;
}

/* .mat-primary{
    background: #39707c !important;    
} */
/* .mat-select-panel.mat-primary{
    background: #fff !important;    
} */
button.mat-primary {
    color: #fff !important;
    font-size: 16px !important;
}

/* .mat-toolbar.mat-primary{
	background-color: #419641;
} */
body .action-tool-bar {
    height: 40px;
    justify-content: space-between;

    /* background-color: rgba(54, 134, 146, 0.6) !important; */
}

.mat-form-field.mat-primary {
    background: transparent !important;
}

.sidenav.mat-drawer.mat-sidenav .mat-toolbar.mat-primary {
    background-color: #fff !important;
    box-shadow: 0px 1px 7px -2px #39707c;
}

.top-breadcrumb {
    margin-bottom: 20px;
}

.top-breadcrumb .template-title {
    font-size: 30px;
    font-weight: normal;
    margin-bottom: 30px;
    position: relative;
    display: inline-block;
}

.top-breadcrumb .template-title:after {
    content: '';
    position: absolute;
    bottom: -13px;
    left: 0;
    height: 3px;
    background: #e27e4b;
    z-index: 99;
    width: 100%;
    border-radius: 32px;
}

.top-breadcrumb .breadcrumb {
    display: flex;
    padding: 0;
    margin-bottom: 40px;
    background-color: transparent;
    list-style: none;
}

.top-breadcrumb .breadcrumb > li + li:before {
    display: none;
}

.top-breadcrumb .breadcrumb li:last-child a::after {
    display: none;
}

.top-breadcrumb .breadcrumb li a::after {
    content: '/';
    position: absolute;
    right: -2px;
}

.top-breadcrumb .breadcrumb li a:not([href]) {
    opacity: 0.4;
}

.top-breadcrumb .breadcrumb li span {
    cursor: pointer;
    display: block;
    font-size: 18px;
    font-family: inherit;
    opacity: 0.8;
    color: black;
    padding-right: 16px;
    margin-right: 9px;
    position: relative;
    display: flex;
    align-items: baseline;
    text-decoration: none;
}

.top-breadcrumb .breadcrumb li a .material-icons {
    font-size: 20px;
    position: relative;
    line-height: 0;
    top: 2px;
}

.top-breadcrumb .breadcrumb li a {
    display: block;
    font-size: 18px;
    font-family: inherit;
    opacity: 0.8;
    color: black;
    padding-right: 16px;
    margin-right: 9px;
    position: relative;
    display: flex;
    align-items: baseline;
    text-decoration: none;
}

.top-breadcrumb button.mat-primary {
    box-shadow: -2px 2px 4px 0px #b6b6d6;
}

.mat-header-cell {
    font-size: 18px !important;
    font-weight: 500 !important;
    color: black !important;
    text-transform: capitalize;
}

.cdk-overlay-pane.fc-modal-dialog {
    width: auto !important;
    height: auto !important;
}

button.mat-menu-item:last-child {
    border-bottom: 0;
}

button.mat-menu-item {
    width: 100%;
    border-bottom: 1px solid #dedede;
}

.mat-form-field {
    font-size: 18px !important;
    font-family: "Futura PT";
}

.mat-card-header, .mat-card-header-text {
    margin: 0 !important;
}

.mat-card-header .cancle-btn {
    opacity: 0.8;
    position: absolute;
    right: 14px;
    top: 14px;
    color: #f16b62;
    transform: rotate(45deg);
}

.mat-card-header .mat-card-title {
    font-size: 30px !important;

    /* border-bottom: 3px solid #ec8d58; */
    margin-bottom: 14px !important;
    display: inline-block;

    @media screen and (max-width: 580px) {
        font-size: 24px !important;
    }
}

.mat-raised-button.mat-warn {
    background-color: #f16b62 !important;
}

.mat-nav-list .mat-list-item {
    text-transform: capitalize;
}

.mat-form-field-required-marker {
    color: #f44336;
}

.fc-bottom-nav {
    width: 100%;
    box-shadow: 0px 0px 4px 3px #aba6a6;
}

.fc-bottom-nav .mat-tab-links {
    display: flex;
    width: 100%;
    justify-content: space-between;
}

.fc-bottom-nav .mat-tab-links .fc-tab-link {
    opacity: 1 !important;
    color: #fff;
    padding-top: 3px;
    min-width: auto;
}

.fc-bottom-nav .mat-tab-links .mat-tab-link.mat-tab-disabled {
    color: rgba(255, 255, 255, 0.59);
}

.mat-tab-header-pagination-disabled .mat-tab-header-pagination-chevron {
    border-color: rgba(242, 242, 242, 0.59) !important;
}

.fc-bottom-nav .mat-tab-header-pagination-chevron {
    border-color: rgb(255, 255, 255) !important;
}

.cdk-global-overlay-wrapper {
    justify-content: center !important;
    align-items: center !important;
}

mat-option {
    text-transform: capitalize;
}

.list-container {
    height: calc(100vh - 70px);
    padding: 24px;
    padding-bottom: 12px;
    margin: 0 !important;
    overflow: auto;
    overflow-x: hidden;
}

.association-div button {
    margin-right: 12px !important;
    margin-bottom: 20px;
    text-transform: capitalize;
}

.table-container {
    overflow: auto;
}

.list-container .table-container .mat-table {
    box-shadow: 0px 5px 5px -3px rgba(0, 0, 0, 0), 0px 8px 10px 1px rgba(0, 0, 0, 0), 0px 3px 14px 2px rgba(0, 0, 0, 0.04);
}

::-webkit-scrollbar {
    width: 0.7em;
    height: 0.6em;
}

::-webkit-scrollbar-track {
    box-shadow: inset 0 0 6px rgb(162, 162, 162);
}

::-webkit-scrollbar-thumb {
    background-color: #006064;
    outline: 1px solid #000000;
}

.delete-dialog-box {
    min-width: 400px;
}

.mat-expansion-panel-body .mat-expansion-panel-body {
    padding: 0 0 16px 3px !important;
}

.mat-expansion-panel-body {
    padding: 0 0 16px 24px !important;
}

.mat-expansion-panel-content {
    position: relative;
}

.mat-expansion-panel-content:after {
    content: '';
    position: absolute;
    height: calc(100% + 14px);
    width: 1px;
    background: #d0cfcf;
    top: -14px;
    left: 25px;
    opacity: 0.5;
}

.mat-expansion-panel-content .mat-expansion-panel-content:after {
    display: none;
}

.spinner-container {
    margin: auto;
    position: fixed;
    z-index: 9;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.78);
}

.list-container .list-container {
    overflow: initial !important;
}

.fc-text-right {
    text-align: right;
}

.fc-text-center {
    text-align: center;
}

.full-page {
    height: calc(100% - 70px);
}

.full-width {
    width: 100%;
}

figure{
	margin: 0;
}

* {
    box-sizing: border-box;
}

/* custom grid css Ends */

.mat-dialog-container mat-card-content.mat-card-content {
    overflow: auto;
    max-height: calc(100vh - 145px);
    overflow-x: hidden;
}

.mat-header-cell, .mat-sort-header-button {
    white-space: nowrap;
    text-transform: capitalize;
}

/* custom grid css starts */
.fc-row {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    margin-right: -15px;
    margin-left: -15px;
}

.mat-dialog-actions.fc-text-right {
    justify-content: flex-end;
}

.mat-form-field-label {
    text-transform: capitalize;
}

.list-container .mat-expansion-panel-content:after {
    display: none;
}

.tools button.mat-primary, .block-tools button.mat-primary {
    color: #333 !important;
}

section.small-spinner-container mat-spinner {
    height: 44px !important;
    width: 44px !important;
    margin: 27px auto 0;
}

section.small-spinner-container svg {
    width: 44px !important;
    height: 44px !important;
}

//  Grid css  fc start

.fc-row {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    margin-right: -15px;
    margin-left: -15px;
}

.no-gutters > [class*=col-] {
    padding-right: 0;
    padding-left: 0;
}

.fc-col,
.fc-col-1,
.fc-col-10,
.fc-col-11,
.fc-col-12,
.fc-col-2,
.fc-col-3,
.fc-col-4,
.fc-col-5,
.fc-col-6,
.fc-col-7,
.fc-col-8,
.fc-col-9,
.fc-col-auto,
.fc-col-lg,
.fc-col-lg-1,
.fc-col-lg-10,
.fc-col-lg-11,
.fc-col-lg-12,
.fc-col-lg-2,
.fc-col-lg-3,
.fc-col-lg-4,
.fc-col-lg-5,
.fc-col-lg-6,
.fc-col-lg-7,
.fc-col-lg-8,
.fc-col-lg-9,
.fc-col-lg-auto,
.fc-col-md,
.fc-col-md-1,
.fc-col-md-10,
.fc-col-md-11,
.fc-col-md-12,
.fc-col-md-2,
.fc-col-md-3,
.fc-col-md-4,
.fc-col-md-5,
.fc-col-md-6,
.fc-col-md-7,
.fc-col-md-8,
.fc-col-md-9,
.fc-col-md-auto,
.fc-col-sm,
.fc-col-sm-1,
.fc-col-sm-10,
.fc-col-sm-11,
.fc-col-sm-12,
.fc-col-sm-2,
.fc-col-sm-3,
.fc-col-sm-4,
.fc-col-sm-5,
.fc-col-sm-6,
.fc-col-sm-7,
.fc-col-sm-8,
.fc-col-sm-9,
.fc-col-sm-auto,
.fc-col-xl,
.fc-col-xl-1,
.fc-col-xl-10,
.fc-col-xl-11,
.fc-col-xl-12,
.fc-col-xl-2,
.fc-col-xl-3,
.fc-col-xl-4,
.fc-col-xl-5,
.fc-col-xl-6,
.fc-col-xl-7,
.fc-col-xl-8,
.fc-col-xl-9,
.fc-col-xl-auto {
    position: relative;
    width: 100%;
    min-height: 1px;
    padding-right: 15px;
    padding-left: 15px;
}

.col {
    -ms-flex-preferred-size: 0;
    flex-basis: 0;
    -webkit-box-flex: 1;
    -ms-flex-positive: 1;
    flex-grow: 1;
    max-width: 100%;
}

.fc-col-auto {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 auto;
    flex: 0 0 auto;
    width: auto;
    max-width: none;
}

.fc-col-1 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 8.333333%;
    flex: 0 0 8.333333%;
    max-width: 8.333333%;
}

.fc-col-2 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 16.666667%;
    flex: 0 0 16.666667%;
    max-width: 16.666667%;
}

.fc-col-3 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 25%;
    flex: 0 0 25%;
    max-width: 25%;
}

.fc-col-4 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 33.333333%;
    flex: 0 0 33.333333%;
    max-width: 33.333333%;
}

.fc-col-5 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 41.666667%;
    flex: 0 0 41.666667%;
    max-width: 41.666667%;
}

.fc-col-6 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 50%;
    flex: 0 0 50%;
    max-width: 50%;
}

.fc-col-7 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 58.333333%;
    flex: 0 0 58.333333%;
    max-width: 58.333333%;
}

.fc-col-8 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 66.666667%;
    flex: 0 0 66.666667%;
    max-width: 66.666667%;
}

.fc-col-9 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 75%;
    flex: 0 0 75%;
    max-width: 75%;
}

.fc-col-10 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 83.333333%;
    flex: 0 0 83.333333%;
    max-width: 83.333333%;
}

.fc-col-11 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 91.666667%;
    flex: 0 0 91.666667%;
    max-width: 91.666667%;
}

.fc-col-12 {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 100%;
    flex: 0 0 100%;
    max-width: 100%;
}

@media (min-width: 576px) {
    .fc-col-sm {
        -ms-flex-preferred-size: 0;
        flex-basis: 0;
        -webkit-box-flex: 1;
        -ms-flex-positive: 1;
        flex-grow: 1;
        max-width: 100%;
    }

    .fc-col-sm-auto {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 auto;
        flex: 0 0 auto;
        width: auto;
        max-width: none;
    }

    .fc-col-sm-1 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 8.333333%;
        flex: 0 0 8.333333%;
        max-width: 8.333333%;
    }

    .fc-col-sm-2 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 16.666667%;
        flex: 0 0 16.666667%;
        max-width: 16.666667%;
    }

    .fc-col-sm-3 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 25%;
        flex: 0 0 25%;
        max-width: 25%;
    }

    .fc-col-sm-4 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 33.333333%;
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }

    .fc-col-sm-5 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 41.666667%;
        flex: 0 0 41.666667%;
        max-width: 41.666667%;
    }

    .fc-col-sm-6 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 50%;
        flex: 0 0 50%;
        max-width: 50%;
    }

    .fc-col-sm-7 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 58.333333%;
        flex: 0 0 58.333333%;
        max-width: 58.333333%;
    }

    .fc-col-sm-8 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 66.666667%;
        flex: 0 0 66.666667%;
        max-width: 66.666667%;
    }

    .fc-col-sm-9 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 75%;
        flex: 0 0 75%;
        max-width: 75%;
    }

    .fc-col-sm-10 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 83.333333%;
        flex: 0 0 83.333333%;
        max-width: 83.333333%;
    }

    .fc-col-sm-11 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 91.666667%;
        flex: 0 0 91.666667%;
        max-width: 91.666667%;
    }

    .fc-col-sm-12 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 100%;
        flex: 0 0 100%;
        max-width: 100%;
    }
}

@media (min-width: 768px) {
    .fc-col-md {
        -ms-flex-preferred-size: 0;
        flex-basis: 0;
        -webkit-box-flex: 1;
        -ms-flex-positive: 1;
        flex-grow: 1;
        max-width: 100%;
    }

    .fc-col-md-auto {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 auto;
        flex: 0 0 auto;
        width: auto;
        max-width: none;
    }

    .fc-col-md-1 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 8.333333%;
        flex: 0 0 8.333333%;
        max-width: 8.333333%;
    }

    .fc-col-md-2 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 16.666667%;
        flex: 0 0 16.666667%;
        max-width: 16.666667%;
    }

    .fc-col-md-3 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 25%;
        flex: 0 0 25%;
        max-width: 25%;
    }

    .fc-col-md-4 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 33.333333%;
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }

    .fc-col-md-5 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 41.666667%;
        flex: 0 0 41.666667%;
        max-width: 41.666667%;
    }

    .fc-col-md-6 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 50%;
        flex: 0 0 50%;
        max-width: 50%;
    }

    .fc-col-md-7 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 58.333333%;
        flex: 0 0 58.333333%;
        max-width: 58.333333%;
    }

    .fc-col-md-8 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 66.666667%;
        flex: 0 0 66.666667%;
        max-width: 66.666667%;
    }

    .fc-col-md-9 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 75%;
        flex: 0 0 75%;
        max-width: 75%;
    }

    .fc-col-md-10 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 83.333333%;
        flex: 0 0 83.333333%;
        max-width: 83.333333%;
    }

    .fc-col-md-11 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 91.666667%;
        flex: 0 0 91.666667%;
        max-width: 91.666667%;
    }

    .fc-col-md-12 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 100%;
        flex: 0 0 100%;
        max-width: 100%;
    }
}

@media (min-width: 992px) {
    .fc-col-lg {
        -ms-flex-preferred-size: 0;
        flex-basis: 0;
        -webkit-box-flex: 1;
        -ms-flex-positive: 1;
        flex-grow: 1;
        max-width: 100%;
    }

    .fc-col-lg-auto {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 auto;
        flex: 0 0 auto;
        width: auto;
        max-width: none;
    }

    .fc-col-lg-1 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 8.333333%;
        flex: 0 0 8.333333%;
        max-width: 8.333333%;
    }

    .fc-col-lg-2 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 16.666667%;
        flex: 0 0 16.666667%;
        max-width: 16.666667%;
    }

    .fc-col-lg-3 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 25%;
        flex: 0 0 25%;
        max-width: 25%;
    }

    .fc-col-lg-4 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 33.333333%;
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }

    .fc-col-lg-5 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 41.666667%;
        flex: 0 0 41.666667%;
        max-width: 41.666667%;
    }

    .fc-col-lg-6 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 50%;
        flex: 0 0 50%;
        max-width: 50%;
    }

    .fc-col-lg-7 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 58.333333%;
        flex: 0 0 58.333333%;
        max-width: 58.333333%;
    }

    .fc-col-lg-8 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 66.666667%;
        flex: 0 0 66.666667%;
        max-width: 66.666667%;
    }

    .fc-col-lg-9 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 75%;
        flex: 0 0 75%;
        max-width: 75%;
    }

    .fc-col-lg-10 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 83.333333%;
        flex: 0 0 83.333333%;
        max-width: 83.333333%;
    }

    .fc-col-lg-11 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 91.666667%;
        flex: 0 0 91.666667%;
        max-width: 91.666667%;
    }

    .fc-col-lg-12 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 100%;
        flex: 0 0 100%;
        max-width: 100%;
    }
}

@media (min-width: 1200px) {
    .fc-col-xl {
        -ms-flex-preferred-size: 0;
        flex-basis: 0;
        -webkit-box-flex: 1;
        -ms-flex-positive: 1;
        flex-grow: 1;
        max-width: 100%;
    }

    .fc-col-xl-auto {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 auto;
        flex: 0 0 auto;
        width: auto;
        max-width: none;
    }

    .fc-col-xl-1 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 8.333333%;
        flex: 0 0 8.333333%;
        max-width: 8.333333%;
    }

    .fc-col-xl-2 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 16.666667%;
        flex: 0 0 16.666667%;
        max-width: 16.666667%;
    }

    .fc-col-xl-3 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 25%;
        flex: 0 0 25%;
        max-width: 25%;
    }

    .fc-col-xl-4 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 33.333333%;
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }

    .fc-col-xl-5 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 41.666667%;
        flex: 0 0 41.666667%;
        max-width: 41.666667%;
    }

    .fc-col-xl-6 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 50%;
        flex: 0 0 50%;
        max-width: 50%;
    }

    .fc-col-xl-7 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 58.333333%;
        flex: 0 0 58.333333%;
        max-width: 58.333333%;
    }

    .fc-col-xl-8 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 66.666667%;
        flex: 0 0 66.666667%;
        max-width: 66.666667%;
    }

    .fc-col-xl-9 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 75%;
        flex: 0 0 75%;
        max-width: 75%;
    }

    .fc-col-xl-10 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 83.333333%;
        flex: 0 0 83.333333%;
        max-width: 83.333333%;
    }

    .fc-col-xl-11 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 91.666667%;
        flex: 0 0 91.666667%;
        max-width: 91.666667%;
    }

    .fc-col-xl-12 {
        -webkit-box-flex: 0;
        -ms-flex: 0 0 100%;
        flex: 0 0 100%;
        max-width: 100%;
    }
}

@media (max-width: 1024px) {
    .fc-col-sm-12 {
        -ms-flex: none;
        flex: none;
        display: block;
        width: 100%;
    }
}

@media (max-width: 1440px) {
    .sort-value .toggle-2 {
        margin-bottom: 9px;
    }
}

@media (max-width: 1024px) {
    .mat-sidenav-content .container {
        min-width: 100%;
    }
}

@media (max-width: 991px) {
    .cdk-overlay-pane.fc-modal-dialog {
        min-width: 50%;
    }
}

@media (max-width: 767px) {
    .list-container .list-container {
        padding: 0 !important;
    }

    .list-container > div > .fc-col-sm-12 {
        padding: 0 !important;
    }

    .list-container {
        // height: calc(100% - 40px) !important;
        padding: 15px 15px 50px !important;
    }

    .delete-dialog-box {
        min-width: 300px;
    }

    .association-div .text-right {
        text-align: left;
    }

    .mat-drawer-transition .mat-drawer-content {
        height: calc(100% - 50px);
    }

    .top-breadcrumb .template-title {
        font-size: 25px;
    }

    .top-breadcrumb .breadcrumb {
        margin-bottom: 12px;
    }

    .grid-row-list {
        flex-direction: column;
    }
}

@media (max-width: 580px) {
    .cdk-overlay-pane.fc-modal-dialog {
        min-width: 90%;
    }

    .top-breadcrumb .breadcrumb li a {
        font-size: 14px;
        padding-right: 10px;
        margin-right: 3px;
    }

    .fc-text-right {
        text-align: left;
    }
}

@media screen and (min-height: 676px) and (max-width: 1200px) {
    // .mat-dialog-container mat-card-content.mat-card-content {
    // 	max-height: 600px;
    // 	overflow: auto;
    // 	overflow-x: hidden;
    // }
}

@media (max-height: 600px) {
    // .mat-dialog-container mat-card-content.mat-card-content {
    // 	max-height: 400px;
    // 	overflow: auto;
    // 	overflow-x: hidden;
    // }
}
