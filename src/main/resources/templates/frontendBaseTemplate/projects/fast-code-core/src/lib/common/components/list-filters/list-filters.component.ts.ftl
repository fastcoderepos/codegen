import { Component, OnInit, Output, EventEmitter, Input, ElementRef, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { IListColumn, listColumnType } from '../../ilistColumn';
import { MatDialog, MatDialogRef } from '@angular/material';
import { MatAutocompleteSelectedEvent, MatAutocomplete } from '@angular/material';
import { ISearchField, operatorType } from './ISearchCriteria';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-list-filters',
  templateUrl: './list-filters.component.html',
  styleUrls: ['./list-filters.component.scss']
})
export class ListFiltersComponent implements OnInit {
  @Input('matChipInputAddOnBlur')
  addOnBlur: boolean

  @Input('matChipInputSeparatorKeyCodes')
  separatorKeysCodes: number[]

  @Output() onSearch: EventEmitter<any> = new EventEmitter();
  @Input() columnsList: IListColumn[];
  filterFields: IListColumn[] = [];
  selectedFilterFields: ISearchField[] = [];
  selectedDisplayFilterFields: any[] = [];
  noFilterableFields: boolean = true;

  basicFilterForm: FormGroup;
  detailsFilterForm: FormGroup;
  showFilters = false;
  filterButtonText = "Show filters";

  filterCtrl = new FormControl();

  operators: any;
  booleanOptions: string[] = ['True', 'False'];

  @ViewChild('filterInput', { read: ElementRef, static: false }) filterInput: ElementRef<HTMLInputElement>;
  @ViewChild('auto', { read: MatAutocomplete, static: false }) matAutocomplete: MatAutocomplete;


  addFieldDialogRef: MatDialogRef<any>;

  constructor(
    private formBuilder: FormBuilder,
    public dialog: MatDialog,
    public translate: TranslateService,
  ) { }

  ngOnInit() {
    this.initializeFilterForms();
  }

  initializeFilterForms(): void {
    this.basicFilterForm = this.formBuilder.group({
      fieldName: [''],
      searchValue: [''],
      startingValue: [''],
      endingValue: [''],
      operator: ['', Validators.required],
    });
    this.basicFilterForm.addControl("searchText", new FormControl(''));
    this.basicFilterForm.addControl("addFilter", new FormControl(''));

    this.columnsList.forEach((column) => {
      if (column.filter) {
        this.noFilterableFields = false;
        this.filterFields.push(column);
      }
    });
  }

  search(): void {
    if (this.field) {
      this.selectFilterField();
      this.filterFields.splice(this.filterFields.findIndex(filterField => filterField === this.field), 1);
      this.filterCtrl.setValue(null);
    }
    this.onSearch.emit(this.selectedFilterFields);
    this.basicFilterForm.reset();
    this.mySelector = false;
  }

  selectFilterField(){
    let formData = this.basicFilterForm.value;
    this.parseDateFields(formData);
    this.setSelectedDisplayFilterfield(formData);
    this.selectedFilterFields.push(formData);
  }

  parseDateFields(formData) {
    let searchValue = formData.searchValue;
    let startingValue = formData.startingValue;
    let endingValue = formData.endingValue;

    if (this.field.type == listColumnType.Date) {
      if (searchValue) {
        searchValue = new Date(searchValue.toString()).toLocaleDateString();
        formData.searchValue = this.parseDateToDefaultStringFormat(new Date(searchValue));
      }
      if (startingValue) {
        startingValue = new Date(startingValue.toString()).toLocaleDateString();
        formData.startingValue = this.parseDateToDefaultStringFormat(new Date(startingValue));
      }
      if (endingValue) {
        endingValue = new Date(endingValue.toString()).toLocaleDateString();
        formData.endingValue = this.parseDateToDefaultStringFormat(new Date(endingValue));
      }
    }
  }

  setSelectedDisplayFilterfield(formData) {
    switch (formData.operator) {
      case operatorType.Contains:
        this.selectedDisplayFilterFields.push(formData.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.CONTAINS') + " \"" + formData.searchValue + "\"");
        break;
      case operatorType.Equals:
        this.selectedDisplayFilterFields.push(formData.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.EQUALS') + " \"" + formData.searchValue + "\"");
        break;
      case operatorType.NotEqual:
        this.selectedDisplayFilterFields.push(formData.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.NOT-EQUAL') + " \"" + formData.searchValue + "\"");
        break;
      case operatorType.Range:
        let displayField = formData.fieldName + ":";

        if (formData.startingValue) {
          displayField = displayField + " " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.FROM') + " \"" + formData.startingValue + "\"";
        }

        if (formData.endingValue) {
          displayField = displayField + " " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.TO') + " \"" + formData.endingValue + "\"";
        }
        this.selectedDisplayFilterFields.push(displayField);
        break;
    }
  }

  // default format: yyyy-MM-dd HH:mm:ss.SSS
  parseDateToDefaultStringFormat(d: Date): string {
    var datestring =
      d.getFullYear() + "-" +
      ("0" + (d.getMonth() + 1)).slice(-2) + "-" +
      ("0" + d.getDate()).slice(-2) + " " +
      ("0" + d.getHours()).slice(-2) + ":" +
      ("0" + d.getMinutes()).slice(-2) + ":" +
      ("0" + d.getSeconds()).slice(-2) + "." +
      ("00" + d.getMilliseconds()).slice(-3)
      ;

    return datestring;
  }
  mySelector: Boolean = false;
  field: IListColumn;
  selected(event: MatAutocompleteSelectedEvent): void {
    console.log("Selct Value Event :", event);
    //getting Icolumnfield object for selected field
    this.field = this.filterFields.find(x => x.label == event.option.value);
    this.basicFilterForm.controls['fieldName'].setValue(this.field.column);
    this.setOperators();
    this.mySelector = true;
  }

  remove(field: string, index: number): void {
    // const index = this.selectedDisplayFilterFields.indexOf(field);

    // get listcolumn object from filter field
    let filterField = this.columnsList.find(x => {
      return x.label == field.split(':')[0];
    });

    // re-add field to filter fields
    this.filterFields.push(filterField);

    this.selectedDisplayFilterFields.splice(index, 1);
    this.selectedFilterFields.splice(index, 1);
    this.onSearch.emit(this.selectedFilterFields);
  }

  setOperators() {
    this.operators = Object.keys(operatorType).map(k => operatorType[k as any]);
    if (this.field.type == listColumnType.String) {
      this.operators.splice(this.operators.indexOf(operatorType.Range), 1);
    }
    else if (this.field.type == listColumnType.Boolean) {
      this.operators.splice(this.operators.indexOf(operatorType.Contains), 1);
      this.operators.splice(this.operators.indexOf(operatorType.Range), 1);
    }
    else {
      this.operators.splice(this.operators.indexOf(operatorType.Contains), 1);
    }
  }
}