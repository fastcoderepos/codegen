<div fxLayout fxLayoutGap="20" class="process-container">
  <div div fxLayout="column" *ngIf="showList || !isMediumDeviceOrLess" fxFlex="{{listFlexWidth}}" class="process-list">

    <div class="process-list-header">

      <div *ngIf="!filter.expanded">
        <div class="filter-icon-expand noselect">
          <span (click)="expandFilter()">
            {{'TASK.FILTER.SHOW' | translate}}<i class="material-icons">expand_more</i>
          </span>
        </div>
      </div>

      <div *ngIf="filter.expanded">
        <div class="filter-icon-collapse noselect">
          <span (click)="collapseFilter()">
            {{'TASK.FILTER.HIDE' | translate}}<i class="material-icons">expand_less</i>
          </span>
        </div>
      </div>

      <div class="summary" *ngIf="filter.expanded">
        <div class="form-group">
          <label translate="PROCESS.FILTER.STATE"></label>
          <div class="state-selection toggle">
            <div class="toggle-3" *ngFor="let option of stateFilterOptions"
              [ngClass]="{'active' : filter.param.state.id == option.id}">
              <button class="state-btn" (click)="selectStateFilter(option)">{{option.title | translate}}</button>
            </div>
          </div>
        </div>

        <mat-form-field class="full-width">
          <label translate="PROCESS.FILTER.APP"></label>
          <mat-select [disabled]="filter.loading" (selectionChange)="loadProcessInstances(false)"
            [(ngModel)]="filter.param.appDefinitionKey">
            <mat-option *ngFor="let option of apps" [value]="option.appDefinitionKey">
              {{ (option.name? option.name : 'PROCESS.FILTER.APP-PLACEHOLDER') | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>

      </div>
    </div>

    <div class="sort-value-block">
      <div class="sort-value">
        <mat-form-field class="full-width">
          <mat-select (selectionChange)="changeSort()" [(ngModel)]="filter.param.sort">
            <mat-option *ngFor="let sort of sorts" [value]="sort.id">
              {{sort.title | translate}}
            </mat-option>
          </mat-select>
        </mat-form-field>
      </div>

      <div class="create-process">
        <button mat-flat-button color="primary" (click)="createProcessInstance()">
          {{'PROCESS.ACTION.CREATE' | translate}}
        </button>
      </div>
    </div>

    <mat-progress-bar *ngIf="filter.loading" mode="indeterminate"></mat-progress-bar>
    <div class="list">
      <div *ngFor="let processInstance of processInstances"
        [ngClass]="{'list-item': true,'active': selectedProcessInstance.id == processInstance.id}"
        (click)="selectProcessInstance(processInstance)">
        <div fxLayout="row">

          <div class="title" fxFlex>{{processInstance.name && processInstance.name ||
            processInstance.processDefinitionName}}</div>

          <div fxFlex="nogrow" class="badge" *ngIf="!processInstance.ended">
            {{'PROCESS.FIELD.STARTED' | translate}} {{(processInstance.started | date:'medium')}}
          </div>
          <div fxFlex="nogrow" class="badge" *ngIf="processInstance.ended">
            {{'PROCESS.FIELD.ENDED' | translate}} {{(processInstance.ended | date:'medium')}}
          </div>
        </div>

        <div fxLayout="row" *ngIf="processInstance.startedBy">
          {{'PROCESS.MESSAGE.STARTED-BY' | translate}} {{processInstance.startedBy.firstName &&
          processInstance.startedBy.firstName != 'null' ? processInstance.startedBy.firstName : ''}}
          {{processInstance.startedBy.lastName && processInstance.startedBy.lastName != 'null' ?
          processInstance.startedBy.lastName : ''}}
        </div>
        <div fxLayout="row">
          <span>
            {{processInstance.description && processInstance.description || processInstance.processDefinitionName}}
          </span>
        </div>
      </div>
      <div class="nothing-to-see" *ngIf="processInstances.length == 0">
        <span translate="PROCESS.MESSAGE.NO-INSTANCES"></span>
      </div>
    </div>
  </div>


  <div fxLayout="column" *ngIf="!showList || !isMediumDeviceOrLess" fxFlex="{{detailsFlexWidth}}">
    <button color="accent" mat-flat-button *ngIf="isMediumDeviceOrLess" (click)="showList=!showList">{{'PROCESS.ACTION.TOGGLE-LIST' | translate}}</button>
    <app-process-details
      [ngClass]="{'process-details-wrap': !isMediumDeviceOrLess,'process-details-wrap-small': isMediumDeviceOrLess}"
      fxLayout="column" [processInstance]="selectedProcessInstance" (onCreateProcess)="createProcessInstance()"
      (onCancelProcess)="onCancelProcess()"></app-process-details>
  </div>
</div>