/* You can add global styles to this file, and also import other style files */
@import 'theme1.scss';

@import url('../assets/font.css');
body {
  /* font-family: 'Raleway', sans-serif; */
  font-family: "Futura PT";
  background-color: #eef1f1;
  /* padding-bottom: 20px; */
}
h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6, p, a, span, div{
  font-family: "Futura PT";
}




html, body { height: 100%; }
body { margin: 0; font-family: 'Roboto', sans-serif; }
[hidden] { display: none !important;}
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
    background-color:  #8bc34a;     
}
   
.subnav .mat-radio-label {
    font-size: 13px;
}


/* .mat-primary{
    background: #39707c !important;    
} */
/* .mat-select-panel.mat-primary{
    background: #fff !important;    
} */
button.mat-primary{
  color:#fff !important;
  font-size:16px !important;
}
/* .mat-toolbar.mat-primary{
  background-color: #419641;
} */
body .action-tool-bar {
    height: 40px;
    justify-content: space-between;
    /* background-color: rgba(54, 134, 146, 0.6) !important; */
}
.mat-form-field.mat-primary{
    background: transparent !important;
}
.sidenav.mat-drawer.mat-sidenav .mat-toolbar.mat-primary {
    background-color: #fff !important;
    box-shadow: 0px 1px 7px -2px #39707c;
}
 

.top-breadcum{ margin-bottom:20px;}
.top-breadcum .template-title{ 
  font-size: 30px;
    font-weight: normal;
    margin-bottom: 30px;
    position: relative;
    display: inline-block;

}
.top-breadcum .template-title:after {
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
.top-breadcum .breadcum{     display: flex;
    padding: 0; margin-bottom:40px;
    list-style: none;}
.top-breadcum .breadcum li:last-child a::after{ display:none;}
  .top-breadcum .breadcum li a::after{
  content:'/';
  position: absolute;
  right:-2px;

}
  .top-breadcum .breadcum li a:not([href]) {
    opacity:0.4;
  }
    .top-breadcum .breadcum li a .material-icons{
      font-size: 20px;
    position: relative;
    line-height: 0;
    top: 2px;
    }
      .top-breadcum .breadcum li a {
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
.top-breadcum button.mat-primary{
  box-shadow: -2px 2px 4px 0px #b6b6d6;
}
.mat-header-cell {
    font-size: 18px !important;
    font-weight: 500 !important;
    color: black !important;
    text-transform: capitalize;
}

.cdk-overlay-pane.fc-modal-dialog{
  width: auto !important;
    height: auto !important;

}
button.mat-menu-item:last-child {border-bottom:0;}
button.mat-menu-item {
width: 100%;
border-bottom: 1px solid #dedede;
}
/* 
.mat-card-actions button {
  width: 100%;
    margin: 0 !important;
    border-radius: 0;
  }
  .mat-card-actions {
  margin-left: -16px !important;
    margin-right: -16px !important;
  display: flex !important;
  justify-content: space-around;
  margin-bottom: -16px !important;
  } */
  .mat-form-field{
    font-size:18px !important;
    font-family: "Futura PT";
  }

  .mat-card-header, .mat-card-header-text{ margin:0 !important;}
  .mat-card-header .cancle-btn{
    opacity: 0.8;
    position: absolute;
    right: 14px;
    top: 14px;
    color: #f16b62;
    transform: rotate(45deg);
  }
    .mat-card-header .mat-card-title{
    font-size: 30px !important;
    /* border-bottom: 3px solid #ec8d58; */
    margin-bottom: 14px !important;
    display: inline-block;
  }
  .mat-raised-button.mat-warn{
  background-color: #f16b62 !important;
  }

  .mat-nav-list .mat-list-item{
  text-transform: capitalize;
  }

  .mat-form-field-required-marker {
    color: #f44336;
}



.fc-bottom-nav{
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
    padding-top: 3px;    min-width: auto;
}
.fc-bottom-nav .mat-tab-links .mat-tab-link.mat-tab-disabled{
  color:rgba(255, 255, 255, 0.59);
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

mat-datepicker-content.mat-datepicker-content.mat-primary {
    background: #fff !important;
}
/* .mat-calendar-body-selected {
    background-color: #39707c;
    color: white;
} */

mat-option {
    text-transform: capitalize;
}

.list-container {   
  height:calc(100vh - 70px) !important;
  padding:24px;
  padding-bottom:12px;
  margin:0 !important;
  overflow:auto;
  overflow-x: hidden;
}
.association-div button{
  margin-right: 12px !important;
  margin-bottom:20px;
  text-transform:capitalize;
}
.table-container{overflow:auto;}

.list-container .table-container .mat-table {   
    box-shadow: 0px 5px 5px -3px rgba(0, 0, 0, 0), 0px 8px 10px 1px rgba(0, 0, 0, 0), 0px 3px 14px 2px rgba(0, 0, 0, 0.04);
}

::-webkit-scrollbar {
  width: 0.7em;
  height:0.6em;
  }
  
::-webkit-scrollbar-track {
  box-shadow: inset 0 0 6px rgb(162, 162, 162);
  }
  
  ::-webkit-scrollbar-thumb {
  background-color: #006064;
    outline: 1px solid #000000;
  }

  .delete-dialog-box{
    min-width:400px;
  }
  /* body .mat-form-field.mat-focused .mat-form-field-label, body .mat-form-field.mat-focused.mat-primary .mat-select-arrow, .mat-datepicker-toggle-active{
  color: #39707c;
  }
  body .mat-form-field.mat-focused .mat-form-field-ripple,.mat-calendar-body-selected{
  background-color: #39707c;
  } */


  .mat-expansion-panel-body .mat-expansion-panel-body {
  padding: 0 0 16px 3px !important;
  }
  .mat-expansion-panel-body {
  padding: 0 0 16px 24px !important;
  }
  .mat-expansion-panel-content{
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

.mat-expansion-panel-content .mat-expansion-panel-content:after{
  display:none;
}


.spinner-container{
  margin: auto;position: fixed;z-index: 9;left: 0;right: 0;top: 0;bottom: 0;display: flex;align-items: center;justify-content: center;background: rgba(255, 255, 255, 0.78);
}

.list-container .list-container {
  overflow:initial !important;
}

/* custom grid css starts */
.fb-row{
  display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    margin-right: -15px;
    margin-left: -15px;
}
.fb-col-lg-1, 
.fb-col-lg-2, 
.fb-col-lg-3, 
.fb-col-lg-4, 
.fb-col-lg-5, 
.fb-col-lg-6, 
.fb-col-lg-7, 
.fb-col-lg-8, 
.fb-col-lg-9, 
.fb-col-lg-10, 
.fb-col-lg-11, 
.fb-col-lg-12,
.fb-col-md-1, 
.fb-col-md-2, 
.fb-col-md-3, 
.fb-col-md-4, 
.fb-col-md-5, 
.fb-col-md-6, 
.fb-col-md-7, 
.fb-col-md-8, 
.fb-col-md-9, 
.fb-col-md-10, 
.fb-col-md-11, 
.fb-col-md-12,
.fb-col-sm-1, 
.fb-col-sm-2, 
.fb-col-sm-3, 
.fb-col-sm-4, 
.fb-col-sm-5, 
.fb-col-sm-6, 
.fb-col-sm-7, 
.fb-col-sm-8, 
.fb-col-sm-9, 
.fb-col-sm-10, 
.fb-col-sm-11, 
.fb-col-sm-12
{
  padding:0 15px;
}

@media (min-width: 768px){
  .fb-col-sm-12 {   
    -ms-flex: 0 0 100%;
    flex: 0 0 100%;
    max-width: 100%;
  }
  .fb-col-sm-6 {    
    -ms-flex: 0 0 50%;
    flex: 0 0 50%;
    max-width: 50%;
  }
  .fb-col-sm-4{
    -ms-flex: 0 0 33.333333%;
    flex: 0 0 33.333333%;
    max-width: 33.333333%;
  }
  .fb-col-sm-9 {
    -ms-flex: 0 0 75%;
    flex: 0 0 75%;
    max-width: 75%;
  }
  .fb-col-sm-8 {
    -ms-flex: 0 0 66.666667%;
    flex: 0 0 66.666667%;
    max-width: 66.666667%;
  }
  

}

@media (min-width: 992px){
  .fb-col-md-6 {    
    -ms-flex: 0 0 50%;
    flex: 0 0 50%;
    max-width: 50%;
  }.fb-col-md-3 {
    -ms-flex: 0 0 25%;
    flex: 0 0 25%;
    max-width: 25%;
  }
  .fb-col-md-4{
    -ms-flex: 0 0 33.333333%;
    flex: 0 0 33.333333%;
    max-width: 33.333333%;
  }
  .fb-col-md-9 {
    -ms-flex: 0 0 75%;
    flex: 0 0 75%;
    max-width: 75%;
  }
  .fb-col-md-8 {
    -ms-flex: 0 0 66.666667%;
    flex: 0 0 66.666667%;
    max-width: 66.666667%;
  }
}

@media (min-width: 1200px){
  .fb-col-lg-2 {    
    -ms-flex: 0 0 16.666666666666664%;
    flex: 0 0 16.666666666666664%;
    max-width: 16.666666666666664%;
  }
  .fb-col-lg-10 {   
    -ms-flex: 0 0 83.33333333333334%;
    flex: 0 0 83.33333333333334%;
    max-width: 83.33333333333334%;
  }
}

.fb-text-right{
  text-align:right;
}
.full-page{
  height:calc(100% - 70px);
}

* {
  box-sizing: border-box;
}

.full-width {
  width: 100%;
}
/* custom grid css Ends */

.mat-dialog-container mat-card-content.mat-card-content {
    overflow: auto;
    max-height: calc(100vh - 145px);
    overflow-x: hidden;
}

.checkbox-container{
  display: flex;
  height: 60px;
  align-items: center;
}

.mat-checkbox{
  font-size: 18px !important; 
}












@media (max-width:1440px){
  .sort-value .toggle-2{margin-bottom:9px;}
}



@media (max-width:1024px){
  .mat-sidenav-content .container{
    min-width:100%;
  }
}
@media (max-width:991px){
  .cdk-overlay-pane.fc-modal-dialog{min-width:50%;}
}
@media (max-width:767px){
    .list-container .list-container {
      padding: 0 !important;
    } 

    .list-container>div>.col-sm-12 {
      padding: 0 !important;
    }
  .list-container {   
    // height: calc(100% - 40px) !important;
      padding: 15px 15px 50px !important;
  }
  .delete-dialog-box{
    min-width:300px;
  }
  .association-div .text-right {
    text-align: left;
  }
  .mat-drawer-transition .mat-drawer-content{
    height:calc(100% - 50px);
  }
  .top-breadcum .template-title{font-size: 25px;}
  .top-breadcum .breadcum{    margin-bottom: 12px;}
  .grid-row-list {flex-direction:column;}

  
}

@media (max-width:580px){
  .cdk-overlay-pane.fc-modal-dialog{min-width:90%;}
  .top-breadcum .breadcum li a {
    font-size: 14px;
    padding-right: 10px;
    margin-right: 3px;
  }
  .fb-text-right{
    text-align:left;
  }
  
}


@media screen and (min-height:676px) and (max-width:1200px){
  // .mat-dialog-container mat-card-content.mat-card-content {
  //  max-height: 600px;
  //  overflow: auto;
  //  overflow-x: hidden;
  // }
}

@media (max-height:600px){
  // .mat-dialog-container mat-card-content.mat-card-content {
  //  max-height: 400px;
  //  overflow: auto;
  //  overflow-x: hidden;
  // }
}