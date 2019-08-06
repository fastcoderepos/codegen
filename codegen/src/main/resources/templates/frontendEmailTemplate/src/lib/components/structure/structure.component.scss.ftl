@import '~@angular/material/theming';

.structure {
  display: grid;
  grid-template-columns: 1fr;
  border: 1px solid #ccc;
  position: relative;
  z-index: 0;

  .tools {
    position: absolute;
    left: 50%;
    top: 100%;
    transition: all 0.3s ease-in-out;
    transform: translate(-50%, -60%);
    background-color: white;
    color: gray;
    opacity: 0;
    z-index: 3;
    .structure-move {
      cursor: move;
    }
  }

  // .column {
  //   z-index: 3;
  //   position: relative;
  //   background-color: #ccc;

  //   &:hover {
  //     @include mat-elevation(1);
  //   }
  // }

  // .overlay {
  //   position: absolute;
  //   background-color: #0000004f;
  //   top: 0;
  //   right: 0;
  //   bottom: 0;
  //   left: 0;
  //   opacity: 0;
  //   z-index: 1;
  //   cursor: pointer;
  //   transition: all 0.3s ease-in-out;
  // }

  &:hover {
    @include mat-elevation(1);
    z-index: 1;

    // .overlay {
    //   opacity: 1;
    // }

    .tools {
      transform: translate(-50%, 0%);
      opacity: 1;
      @include mat-elevation(1);
      z-index: 4;
    }
  }

  &.cols_2 {
    grid-template-columns: repeat(2, 1fr);
  }

  &.cols_3 {
    grid-template-columns: repeat(3, 1fr);
  }

  &.cols_4 {
    grid-template-columns: repeat(4, 1fr);
  }

  &.cols_12 {
    grid-template-columns: 60% 40%;
  }

  &.cols_21 {
    grid-template-columns: 40% 60%;
  }
}
