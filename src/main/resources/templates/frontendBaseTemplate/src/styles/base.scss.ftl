/* You can add global styles to this file, and also import other style files */
@import './node_modules/@angular/material/_theming.scss'; //for testing purpose
@import 'theme1.scss';
$fc-margin:8px;
$fc-margin-half:4px;
$fc-margin2:16px;
$fc-margin3:24px;

//row
$fc-row-height3:24px;
$fc-row-height31:28px;
$fc-row-height4:32px;
$fc-row-height41:36px;
$fc-row-height5:40px;
$fc-row-height6:48px;
$fc-row-height7:56px;
$fc-row-height8:64px;
$fc-row-height9:72px;
$fc-row-height10:80px;

//colors
$fc-primary-color: mat-color($fc-theme-primary);
$fc-primary-color-light: mat-color($fc-theme-primary,300);
$fc-accent-color: mat-color($fc-theme-accent);

.mat-table {
    overflow: auto;

    mat-row, mat-header-row, mat-footer-row {
        padding-left: 24px;
        padding-right: 24px;
    }

    mat-cell{
        padding: 2px;
        word-break: break-all;
    }

    mat-cell:first-child, mat-footer-cell:first-child, mat-header-cell:first-child {
        padding-left: 0;
    }

    mat-cell:last-child, mat-footer-cell:last-child, mat-header-cell:last-child {
        padding-right: 0;
    }

    mat-footer-row:after, mat-header-row:after, mat-row:after {
        display: none !important;
    }
}

.mobile-label {
    display: none;
}

.list-container{
    margin:$fc-margin3;
    height: 100%;
}