import { Component, OnInit, Inject, HostListener } from '@angular/core';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';

import { GenericApiService } from '../core/generic-api.service';
import { ActivatedRoute, Router } from "@angular/router";
import { FormBuilder, FormGroup } from '@angular/forms';
import { first } from 'rxjs/operators';
import { of as observableOf, Observable } from 'rxjs';

import { Globals } from '../../globals';

import { IAssociationEntry } from '../core/iassociationentry';
import { PickerDialogService } from '../../common/components/picker/picker-dialog.service';
import { ISearchField, operatorType } from '../../common/components/list-filters/ISearchCriteria';
import { IGlobalPermissionService } from '../core/iglobal-permission.service';

import { CanDeactivateGuard } from '../core/can-deactivate.guard';
import { ErrorService } from '../core/error.service';
@Component({

  template: ''

})
export class BaseNewComponent<E> implements OnInit, CanDeactivateGuard {

  /** 
   * Guard against browser refresh, close, etc.
   * Checks if user has some unsaved changes 
   * before leaving the page.
   */
  @HostListener('window:beforeunload')
  canDeactivate(): Observable<boolean> | boolean {
    // returning true will navigate without confirmation
    // returning false will show a confirm dialog before navigating away
    if (this.itemForm.touched) {
      return false
    }
    return true;
  }

  itemForm: FormGroup;
  loading = false;
  submitted = false;
  title: string = "title";

  pickerDialogRef: MatDialogRef<any>;

  associations: IAssociationEntry[];
  parentAssociations: IAssociationEntry[];

  entityName: string = "";
  IsReadPermission: Boolean = false;
  IsCreatePermission: Boolean = false;
  IsUpdatePermission: Boolean = false;
  IsDeletePermission: Boolean = false;
  globalPermissionService: IGlobalPermissionService;

  isMediumDeviceOrLess: boolean;
  mediumDeviceOrLessDialogSize: string = "100%";
  largerDeviceDialogWidthSize: string = "65%";
  largerDeviceDialogHeightSize: string = "75%";

  errorMessage = '';

  constructor(
    public formBuilder: FormBuilder,
    public router: Router,
    public route: ActivatedRoute,
    public dialog: MatDialog,
    public dialogRef: MatDialogRef<any>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    public global: Globals,
    public pickerDialogService: PickerDialogService,
    public dataService: GenericApiService<E>,
    public errorService: ErrorService
  ) { }

  /**
   * Sets CRUD permissions for entity for
   * currently logged in user.
   */
  setPermissions = () => {
    if (this.globalPermissionService) {
      let entityName = this.entityName.startsWith("I") ? this.entityName.substr(1) : this.entityName;
      this.IsCreatePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "CREATE");
      if (this.IsCreatePermission) {
        this.IsReadPermission = true;
        this.IsDeletePermission = true;
        this.IsUpdatePermission = true;
      } else {
        this.IsDeletePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "DELETE");
        this.IsUpdatePermission = this.globalPermissionService.hasPermissionOnEntity(entityName, "UPDATE");
        this.IsReadPermission = (this.IsDeletePermission || this.IsUpdatePermission) ? true : this.globalPermissionService.hasPermissionOnEntity(entityName, "READ");
      }
    }
  }

  ngOnInit() {
    this.setPermissions();
    this.manageScreenResizing();
  }

  /**
   * Manages screen resizing for responsiveness.
   */
  manageScreenResizing() {
    this.global.isMediumDeviceOrLess$.subscribe(value => {
      this.isMediumDeviceOrLess = value;
      if (this.dialogRef)
        this.dialogRef.updateSize(value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogWidthSize,
          value ? this.mediumDeviceOrLessDialogSize : this.largerDeviceDialogHeightSize);
    });
  }

  /**
   * Gets data from item form and calls 
   * service method to create the item.
   */
  onSubmit() {
    if (this.itemForm.invalid) {
      return;
    }

    this.submitted = true;
    this.loading = true;
    this.dataService.create(this.itemForm.getRawValue())
      .pipe(first())
      .subscribe(
        data => {
          // this.alertService.success('Registration successful', true);
          // this.router.navigate(['/users']);
          this.dialogRef.close(data);
        },
        error => {
          this.errorService.showError("Error Occured while updating");
          this.loading = false;
          this.dialogRef.close(null)

        });
  }

  onCancel(): void {
    this.dialogRef.close(null);
  }

  /**
   * Loads records of given association from service.
   * @param association 
   */
  selectAssociation(association: IAssociationEntry) {
    this.initializePickerPageInfo();
    association.data = [];
    association.service.getAll(association.searchValue, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(items => {
      this.initializePickerPageInfo(); // resetting the picker page info in case callback order is messed up
      this.isLoadingPickerResults = false;
      association.data = items;
      this.updatePickerPageInfo(items);
    },
      error => {
        this.errorMessage = <any>error;
        this.errorService.showError("An error occured while fetching results");
      }
    );
  }
  isLoadingPickerResults = true;

  currentPickerPage: number;
  pickerPageSize: number;
  lastProcessedOffsetPicker: number;
  hasMoreRecordsPicker: boolean;

  searchValuePicker: ISearchField[] = [];
  pickerItemsObservable: Observable<any>;

  /**
   * Initializes/Resets paging information of data list 
   * of association showing in autocomplete options.
   */
  initializePickerPageInfo() {
    this.hasMoreRecordsPicker = true;
    this.pickerPageSize = 30;
    this.lastProcessedOffsetPicker = -1;
    this.currentPickerPage = 0;
  }

  /**
   * Manages paging for virtual scrolling for data list 
   * of association showing in autocomplete options.
   * @param data Item data from the last service call.
   */
  updatePickerPageInfo(data) {
    if (data.length > 0) {
      this.currentPickerPage++;
      this.lastProcessedOffsetPicker += data.length;
    }
    else {
      this.hasMoreRecordsPicker = false;
    }
  }

  /**
   * Loads more data of given association when 
   * list is scrolled to the bottom (virtual scrolling).
   * @param association 
   */
  onPickerScroll(association: IAssociationEntry) {
    if (!this.isLoadingPickerResults && this.hasMoreRecordsPicker && this.lastProcessedOffsetPicker < association.data.length) {
      this.isLoadingPickerResults = true;
      association.service.getAll(association.searchValue, this.currentPickerPage * this.pickerPageSize, this.pickerPageSize).subscribe(
        items => {
          this.isLoadingPickerResults = false;
          association.data = association.data.concat(items);
          this.updatePickerPageInfo(items);
        },
        error => {
          this.errorMessage = <any>error;
          this.errorService.showError("An error occured while fetching more results");
        }
      );
    }
  }

  /**
   * Loads the data meeting given criteria of given association.
   * @param searchValue Filters to be applied.
   * @param association 
   */
  onPickerSearch(searchValue: string, association: IAssociationEntry) {

    let searchField: ISearchField = {
      fieldName: association.referencedDescriptiveField,
      operator: operatorType.Contains,
      searchValue: searchValue ? searchValue : ""
    }
    association.searchValue = [searchField];
    this.selectAssociation(association);
  }

  /**
   * Sets listener to change event of autocomplete
   * fields.
   */
  setPickerSearchListener() {
    this.associations.forEach(association => {
      if (!association.isParent) {
        this.itemForm.get(association.descriptiveField).valueChanges.subscribe(value => this.onPickerSearch(value, association));
      }
    })
  }

  /**
   * Sets form values for given associtaion 
   * when some option is selected. 
   * @param event 
   * @param association 
   */
  onAssociationOptionSelected(event: MatAutocompleteSelectedEvent, association: IAssociationEntry) {
    let selectedOption = event.option.value;
    association.column.forEach(col => {
      this.itemForm.get(col.key).setValue(selectedOption[col.referencedkey]);
    });
    this.itemForm.get(association.descriptiveField).setValue(selectedOption[association.referencedDescriptiveField]);
  }

  checkPassedData() {
    if (this.data) {
      this.itemForm.patchValue(this.data);
    }
  }
}