@import "src/styles/base.scss";

.container {
    height: '400px';
    width: '600px';
}

.action-tool-bar {
    background-color: $fc-primary-color-light !important;
    height: $fc-row-height5;
    justify-content: space-between;

    .middle {
        //flex: 1 1 auto;
   
    }
}

.home-container {
    display: block;

    // justify-content: center;
    //flex-direction: column;
    // align-items: center;
}

.left {
    // width:180px;
    flex: 1 1 250px;
    margin: 24px;
}

.left-card {
    margin-bottom: 24px;
}

.welcome-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;

    h2 {
        align-items: center;

        @media screen and (max-width: 580px) {
            font-size: 18px;
        }
    }
}

.fc-icon {
    color: $fc-primary-color;
    margin-right: 16px;
    font-size: 32px;
}

.item-form {
    display: flex;
    flex-direction: column;
}

.item-card {
    width: 400px;
    padding: 16px;
}

.item-form-container {
    display: flex;

    // justify-content: center;
    flex-direction: column;

    // align-items: center;
    //height: 600px;
}

.item-action {
    display: flex;

    //  justify-content: flex-end;
}

mat-card-header.mat-card-header h4 {
    font-size: 20px;
    text-transform: uppercase;
}

mat-card.mat-card {
    min-height: 249px;
    margin-bottom: 40px;
    justify-content: center;

    h4 {
        text-align: left;
        margin-left: 124px;
        line-height: 30px;
        max-width: 600px;
    }

    p {
        padding-left: 200px;
        text-align: left;
    }
}

figure.icon {
    position: absolute;
    text-align: center;
    width: 105px;
    height: 110px;
    left: 20px;
    opacity: 0.7;
}

figure.icon mat-icon {
    font-size: 84px;
    margin: 0 auto 20px;
    opacity: 0.5;
    color: #006064;
}

.link-share {
    position: absolute;
    right: 0;
    bottom: 0;
    background-color: #006064;
    padding: 10px 18px 5px;
    border-radius: 35px 0px 0px 0;
    color: #fff;
    box-shadow: -1px -1px 6px -2px #bfbfbf;
}

h4.sub-heading {
    font-size: 20px;
}

.main-heading {
    font-size: 21px !important;
}

a{
	color: #428bca;
  text-decoration: none;
}
