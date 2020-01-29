import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from "@angular/platform-browser";
import { DebugElement, NgModule } from '@angular/core';

import { HomeComponent } from './home.component';
import { TestingModule } from '../../testing/utils';
import { Router } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';

describe('HomeComponent', () => {
  let component: HomeComponent;
  let fixture: ComponentFixture<HomeComponent>;
  let el: DebugElement;

  beforeEach(async(() => {

    TestBed.configureTestingModule({
      declarations: [
        HomeComponent
      ].concat(),
      imports: [
        TestingModule,
        RouterTestingModule
      ]
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  <#if AuthenticationType != "none">
  <#if AuthenticationType == "oidc">
  it('should initiate loginflow if auth type is oidc and token is not set', async () => {

    spyOn(component.authenticationService, "login").and.returnValue();
    spyOnProperty(component.authenticationService, "token", "get").and.returnValue(null);
    fixture.detectChanges();

    el = fixture.debugElement.query(By.css('button[name=login]'));
    el.nativeElement.click();

    expect(component.authenticationService.login).toHaveBeenCalled();

  });
  <#else>
  it('should navigate to login page if token is not set', async () => {

    const router = TestBed.get(Router);
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);
    spyOnProperty(component.authenticationService, "token", "get").and.returnValue(null);
    fixture.detectChanges();

    el = fixture.debugElement.query(By.css('button[name=login]'));
    el.nativeElement.click();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['/login'], { queryParams: { returnUrl: 'dashboard' } });

  });

  it('should navigate to dashboard if token is set', async () => {
    const router = TestBed.get(Router);
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);
    spyOnProperty(component.authenticationService, "token", "get").and.returnValue("token");
    fixture.detectChanges();

    el = fixture.debugElement.query(By.css('button[name=dashboard]'));
    el.nativeElement.click();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['dashboard']);
  });
  </#if>
  <#else>
  it('should navigate to dashboard', async () => {
    const router = TestBed.get(Router);
    let navigationSpy = spyOn(router, 'navigate').and.returnValue(null);

    el = fixture.debugElement.query(By.css('button[name=dashboard]'));
    el.nativeElement.click();

    let responsePromise = navigationSpy.calls.mostRecent().returnValue;
    await responsePromise;
      
    expect(router.navigate).toHaveBeenCalledWith(['dashboard']);
  });
  </#if>

});