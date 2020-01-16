@import 'src/styles/base.scss';
.login-container {
    height: calc(100%);
    overflow: auto;
    display: flex;
    // justify-content: center;
    flex-direction: column;   
     background-color: #47b3c3;
    background-image:url('../../assets/images/login_bg.jpg');
    background-size: cover;
    background-position: center;

    // align-items: center;
    background: linear-gradient(346deg, rgba(43,100,109,1) 0%, rgba(54,134,146,1) 35%, rgba(71,179,195,1) 100%);
}

// .login-container:after {
//   content: '';
//   position: absolute;
//   width: 200%;
//   height: 100%;
//   background: #47b3c2;
//   top: -3%;
//   z-index: 0;
//   transform: rotate(34deg);
//   background: linear-gradient(346deg, #2b646d 0%, #368692 35%, #47b3c3 100%);
//   box-shadow: 1px 1px 8px 1px #2a6f79;
// }

.action-tool-bar {    
    background-color: $fc-primary-color-light !important;
    height:$fc-row-height5;
    justify-content: space-between;
    .middle{
        //flex: 1 1 auto;
    }
   
  }
  .item-form {
    display: flex;
  flex-direction: column;
  }
  .item-card {
    max-width: 450px;
    width: 100%;
    margin: auto;
    padding: 44px 43px 60px;
    border-radius: 16px;
    position: relative;
    z-index: 9;
    background-image: url('../../assets/images/form-bg1.png');
    background-size: cover;
    background-position: top;
    @media screen and (max-width:479px) {
      padding: 44px 15px 15px;
    }

  }
  .item-form-container {
    margin: auto;
  }
  .item-action {
    display: flex;
    justify-content: flex-end;
  }
  .mat-card-subtitle, .mat-card-content {
    font-size: 20px;
}

.logo{
  margin-bottom:0px;
}
.btn-submit{
  margin:25px auto 0 !important;
  font-size: 18px;
  min-width: 270px;
  padding: 10px 20px;
  border-radius: 25px;
  width: 100%;
  font-family: "Futura PT";
}
i.material-icons {
  color: rgba(54, 134, 146, 0.52);
  position: relative;
  bottom: -3px;
  font-size: 20px;
}

.login-container .sub-title {
  font-size: 25px;
  font-weight: 600;
  margin-bottom: 40px;
  margin-top: 0;
}

@media (max-width:580px){
  .item-card{ width:calc(100% - 30px);}
}