import { Component, OnInit } from '@angular/core';
import { ILogin } from './ilogin';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup, Validators, ValidationErrors, ValidatorFn } from '@angular/forms';
import { AuthenticationService } from '../core/authentication.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  itemForm: FormGroup;
  errorMessage = '';
  iLogin: ILogin = {} as ILogin;
  loading = false;
  submitted = false;
  returnUrl: string = 'dashboard';
  constructor(
    private formBuilder: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    public authenticationService: AuthenticationService,
  ) { }

  ngOnInit() {
    if (this.route.snapshot.queryParams) {
      this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || 'dashboard';
    }

    if(this.authenticationService.token){
      if (!this.authenticationService.isTokenExpired()) {
        this.router.navigate([this.returnUrl]);
        return;
      }
      else {
        this.authenticationService.logout();
      }
    }
    this.itemForm = this.formBuilder.group({

      userName: ['', Validators.required],
      password: ['', Validators.required]     

    }, { validators: this.validateEmailAndPassword });

  }

  // convenience getter for easy access to form fields
  get f() { return this.itemForm.controls; }
  validateEmailAndPassword: ValidatorFn = (control: FormGroup): ValidationErrors | null => {
    const name = control.get('userName');
    const alterEgo = control.get('password');
    return null;
    /* return   this.authenticationService.postLogin(this.iLogin)
     .pipe(first())
     .subscribe(
         data => {                  
         return null
         },
         error => {
         
             return { passwordUserNameError: true }
         });*/
  };

  onSubmit() {
    this.submitted = true;

    // stop here if form is invalid
    if (this.itemForm.invalid) {
      return;
    }
    this.iLogin.userName = this.itemForm.value.userName;
    this.iLogin.password = this.itemForm.value.password;

    this.loading = true;
    this.authenticationService.login(this.iLogin)
      // .pipe(first())
      .subscribe(
        data => {
          this.loading = false;
          this.authenticationService.permissionsChange.next();
          // this.global.isAuthenticated = true;
          this.router.navigate([this.returnUrl]);
        },
        error => {
          // this.itemForm.controls['password'].setErrors({'incorrect': true});
          this.itemForm.setErrors({ 'passwordUserNameError': true });
          this.loading = false;
          // this.global.isAuthenticated = true;
        });
  }
  onBack(): void {
    this.router.navigate(['/']);
  }

}