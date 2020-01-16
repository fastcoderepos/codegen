@import url('https://fonts.googleapis.com/css?family=Merriweather+Sans');

figure.logo {
    position: absolute;
    left: 20px;
	top: 20px;	
}
.logo img{
	height:44px;
}

main{
	height: 100%;
	width: 100%;
	background: #fff;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	/* background-image:url('../../assets/images/login_bg.png');
    background-size: cover;
	background-position: center; */
	background-color: #47b3c3;
	background: linear-gradient(346deg, rgba(43,100,109,1) 0%, rgba(54,134,146,1) 35%, rgba(71,179,195,1) 100%);
	font-family: 'Merriweather Sans', sans-serif}
	
	#errorText{
		font-size: 22px;
		margin: 14px 0;
		color:#fff;
	}
	#errorLink{
		font-size: 20px;
		padding: 12px;
		border: 1px solid;
		color: #fff;
		background-color: transparent;
		text-decoration: none;
		transition: all 0.5s ease-in-out;
		/* &:hover, &:active
			color: #fff;
			background: #000; */}
	#g6219{
		transform-origin: 85px 4px ;
        animation: an1 12s .5s infinite ease-out;}
        
@keyframes an1{
	0%
		{transform: rotate(0)}
	5%
		{transform: rotate(3deg)}
	15%
		{transform: rotate(-2.5deg)}
	25%
		{transform: rotate(2deg)}
	35%
		{transform: rotate(-1.5deg)}
	45%
		{transform: rotate(1deg)}
	55%
		{transform: rotate(-1.5deg)}
	65%
		{transform: rotate(2deg)}
	75%
		{transform: rotate(-2deg)}
	85%
		{transform: rotate(2.5deg)}
	95%
		{transform: rotate(-3deg)}
	100%
        {transform: rotate(0)}
        
}

@media (max-width:1200px){
	svg#svg2 {
		width: 200px;
	}
}