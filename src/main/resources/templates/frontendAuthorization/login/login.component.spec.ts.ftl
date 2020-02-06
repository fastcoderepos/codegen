import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from "@angular/platform-browser";
import { MatDialogRef } from '@angular/material';
import { of, Observable } from 'rxjs';
import { Router, ActivatedRoute } from '@angular/router';

import { LoginComponent } from './login.component';
import { TestingModule, EntryComponents } from '../../testing/utils';
import { ILogin } from './ilogin'
import { DebugElement } from '@angular/core';


describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let data: ILogin = {
    userName: 'userName1',
    password: 'password1'
  };
  let el: DebugElement;

  beforeEach(async(() => {

    TestBed.configureTestingModule({
      declarations: [
        LoginComponent
      ].concat(EntryComponents),
      imports: [TestingModule],
      providers: [
        { provide: MatDialogRef, useValue: { close: (dialogResult: any) => { } } },
      ]

    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should navigate to returnUrl if a valid token exists', async () => {
    const router = TestBed.get(Router);
    const aroutes = TestBed.get(ActivatedRoute);

    aroutes.snapshot.queryParams['returnUrl'] = 'sampleReturn';
    fixture.detectChanges();
    spyOn(component.authenticationService , 'isTokenExpired').and.returnValue(false);
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);

    component.ngOnInit();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['sampleReturn']);

  });

  it('should navigate dashboard if no redirect url is provided and a valid token exists', async () => {
    const router = TestBed.get(Router);
    spyOn(component.authenticationService , 'isTokenExpired').and.returnValue(false);
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);

    component.ngOnInit();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['dashboard']);

  });

  it('should call logout initialize form if token is invalid', async () => {
    spyOn(component.authenticationService , 'decodeToken').and.returnValue({sub: "sub1"});
    spyOn(component.authenticationService , 'isTokenExpired').and.returnValue(true);
    spyOn(component.authenticationService , 'logout').and.returnValue();
    
    component.ngOnInit();
    
    expect(component.authenticationService.logout).toHaveBeenCalled();
    expect(component.itemForm).toBeDefined();

  });

  it('initialize form if token is present', async () => {
    spyOn(component.authenticationService , 'decodeToken').and.returnValue(null);
    component.ngOnInit();
    expect(component.itemForm).toBeDefined();

  });

  it('should run #onSubmit()', async () => {

    component.itemForm.patchValue(data);
    component.itemForm.enable();
    fixture.detectChanges();
    spyOn(component.authenticationService, "login").withArgs(data).and.returnValue(of({}));
    el = fixture.debugElement.query(By.css('button[name=login]'));
    el.nativeElement.click();
    expect(component.authenticationService.login).toHaveBeenCalledWith(data);

  });

  it('should navigate to returnUrl in case of successful authentication', async () => {
    const router = TestBed.get(Router);

    component.returnUrl = 'sampleReturn';
    fixture.detectChanges();
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);

    component.itemForm.patchValue(data);
    component.itemForm.enable();
    fixture.detectChanges();
    spyOn(component.authenticationService, "login").withArgs(data).and.returnValue(of({}));
    el = fixture.debugElement.query(By.css('button[name=login]'));
    el.nativeElement.click();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['sampleReturn']);

  });

  it('should have set passwordUserNameError in form in case of error in authentication', async () => {

    component.itemForm.patchValue(data);
    component.itemForm.enable();
    fixture.detectChanges();
    spyOn(component.authenticationService, "login").withArgs(data).and.returnValue(Observable.create(observer => {
        observer.error(new Error("invalid username or password"))
      })
    );

    el = fixture.debugElement.query(By.css('button[name=login]'));
    el.nativeElement.click();
    expect(component.itemForm.getError('passwordUserNameError')).toBeDefined();

  });

  // it('login button should be disable when form is not valid', async () => {

  //   fixture.detectChanges();
  //   spyOn(component.authenticationService, "login").withArgs(data).and.returnValue(of({}));
  //   el = fixture.debugElement.query(By.css('button[name=login]'));
  //   expect(el.nativeElement.disabled).toBe(true);

  // });

});
