table {
    width: 100%;
}

.table-container {
    overflow: auto;
    width: 100%;
    max-height: calc(100% - 280px);
}

.mat-icon {
    margin-right: 0px;
}

.error-msg .mat-icon {
    position: relative;
    bottom: -7px;
    margin-left: 20px;
}

h2.dialog-header-title {
    margin: 0;
    padding: 0 0 8px;
    border-bottom: 1px solid #d2d2d2;
    position: relative;
}

.mat-dialog-actions.text-right {
    justify-content: flex-end;
}

button.mat-icon-button.mat-button-base.mat-basic {
    position: absolute;
    top: -21px;
    right: -21px;
    background: #f16b62;
    color: #fff;
    padding: 0;
    transform: scale(0.5);
    line-height: 12px;
    opacity: 0.8;
}

@media (max-width: 767px) {
    .mat-table {
        overflow: auto;
        min-width: 600px;
    }
}
