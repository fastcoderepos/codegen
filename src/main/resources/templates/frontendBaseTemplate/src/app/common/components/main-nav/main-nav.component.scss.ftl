.sidenav-container {
  height: 100%;
}

.sidenav {
  width: 300px;
  box-shadow: 3px 0 6px rgba(0,0,0,.24);
  @media screen and (max-width:1200px) {
    width:250px
  }
  .sidenav-list-item {
    box-shadow: 0 0px 0px 0px rgba(0,0,0,.2) !important;    
    height: 55px !important;
    // padding: 0 24px 0 16px;
    font-size: 18px;
    font-weight: 500;
    font-family: "Futura PT";
    @media screen and (max-width:1200px){
        font-size:15px;
    }
  }
  .expansion-panel{
    box-shadow: 0 0 0 0;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    .radio-group {
      display: inline-flex;
      flex-direction: column;
    }
    
    .radio-button {
      margin: 5px 5px 5px 0px;
      padding-left: 16px; 
    }  
  }
  .subnav {
    //margin-left: 8px;
    list-style-type: none;
    padding-top: 0 !important;
  }
  .subnav-header {
    // height:36px !important;
    // padding: 0 24px 0 16px;
    height: 55px !important;
    padding: 0 24px 0 16px;
    font-size: 18px;
    font-weight: 500;
    font-family: "Futura PT";
    @media screen and (max-width:1200px) {
      height: 45px !important;
      padding: 0 24px 0 16px;
      font-size: 15px;
    }
  }
  .mat-sub-list-item {
    min-height: 35px;
    height:auto;
    font-size: 16px;
    color: #929292;
    line-height:30px;
   // box-shadow: 3px 0 6px rgba(0,0,0,.24) ;
   @media screen and (max-width:1200px) {
    min-height: 30px;
    font-size: 15px;
    line-height: 30px;
   }
  }
  .nav-list{
    height: calc(100% - 65px);
    overflow: auto;
  }
}

// .mat-toolbar.mat-primary {
//   position: sticky;
//   background-color: #4c8a92;
//   color: white;
//   top: 0;
//   // background-image:url('../../../../assets/images/login_bg2.jpg');
// }
.fc-sidenav-content{
  overflow: visible !important;
}
.fc-tool-bar{    
  //height:$fc-row-height5;
  justify-content: space-between;
  z-index:9999999;
  .middle{
      //flex: 1 1 auto;
  }
 
}
.fc-bottom-nav {
  position: fixed;
  bottom: 0;
  z-index:999999;
  //background-color: $primary;
}

.loggo{
  img{
    height:60px;
    @media screen and (max-width:767px){
        height:50px;
    }
  }
}
.no-header {
  display: none !important;
}
a.sidenav-list-item .material-icons , mat-expansion-panel-header .material-icons  {
  opacity: 0.5; margin-right:7px;
  @media screen and (max-width:1200px){
    font-size: 20px;
  }
}

.sidebar-toggle-btn{
  position: absolute;
  right: -60px;
  top: 0;
  padding: 8px 7px 2px;
  height: 100%;
  background: transparent;
  border: 0;
  color: #368692;
  border-left: 1px solid;
}
.mat-drawer-opened .sidebar-toggle-btn{
  right:0px;
}

.mat-drawer-content{
  background: #f1f1f1;
  overflow: auto !important;
  height: 100%;
}

.sidenav{
  .nav-list{
    // &::-webkit-scrollbar {
    //   width: 0.7em;
    // }
    
    // &::-webkit-scrollbar-track {
    //   box-shadow: inset 0 0 6px rgba(76, 138, 146, 0.2);
    // }
    
    // &::-webkit-scrollbar-thumb {
    //   background-color: rgb(57, 112, 124);
    //   outline: 1px solid #33636d;
    // }
  }

}
.loggo.mob-logo{
  display:none;
  @media  (max-width:768px) {
      display: inline;
  }
  img{
    height: 45px;
    border-radius: 23px;
  }
}

