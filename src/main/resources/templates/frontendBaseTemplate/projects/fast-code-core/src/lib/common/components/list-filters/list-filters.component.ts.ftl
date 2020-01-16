import { Component, OnInit, Output, EventEmitter, Input, ElementRef, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { IListColumn, listColumnType } from '../../ilistColumn';
import { MatDialog, MatDialogRef } from '@angular/material';
import { MatAutocompleteSelectedEvent, MatChipInputEvent, MatAutocomplete } from '@angular/material';
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

  @ViewChild('filterInput', { read: ElementRef, static: false }) filterInput: ElementRef<HTMLInputElement>;
  @ViewChild('auto', { read: MatAutocomplete, static: false }) matAutocomplete: MatAutocomplete;


  addFieldDialogRef: MatDialogRef<any>;

  constructor(
    private formBuilder: FormBuilder,
    public dialog: MatDialog,
    private translate: TranslateService,
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
    let result = this.basicFilterForm.value;
    let searchValue = result.searchValue;
    let startingValue = result.startingValue;
    let endingValue = result.endingValue;

    if (this.field.type == listColumnType.Date) {
      if (searchValue) {
        searchValue = new Date(searchValue.toString()).toLocaleDateString();
        result.searchValue = this.parseDateToDefaultStringFormat(new Date(searchValue));
      }
      if (startingValue) {
        startingValue = new Date(startingValue.toString()).toLocaleDateString();
        result.startingValue = this.parseDateToDefaultStringFormat(new Date(startingValue));
      }
      if (endingValue) {
        endingValue = new Date(endingValue.toString()).toLocaleDateString();
        result.endingValue = this.parseDateToDefaultStringFormat(new Date(endingValue));
      }
    }

    this.selectedFilterFields.push(result);  
    switch (this.basicFilterForm.controls['operator'].value) {
      case operatorType.Contains:
        this.selectedDisplayFilterFields.push(result.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.CONTAINS') + " \"" + result.searchValue + "\"");
        break;
      case operatorType.Equals:
        this.selectedDisplayFilterFields.push(result.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.EQUALS') + " \"" + result.searchValue + "\"");
        break;
      case operatorType.NotEqual:
        this.selectedDisplayFilterFields.push(result.fieldName + ": " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.NOT-EQUAL') + " \"" + result.searchValue + "\"");
        break;
      case operatorType.Range:
        let displayField = result.fieldName + ":";

        if (this.basicFilterForm.controls['startingValue'].value) {
          displayField = displayField + " " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.FROM') + " \"" + result.startingValue + "\"";
        }

        if (this.basicFilterForm.controls['endingValue'].value) {
          displayField = displayField + " " + this.translate.instant('LIST-FILTERS.FIELD-CRITERIA-DISPLAY.TO') + " \"" + result.endingValue + "\"";
        }
        this.selectedDisplayFilterFields.push(displayField);
        break;
    }
    this.filterFields.splice(this.filterFields.findIndex(filterField => filterField === this.field), 1);
    // this.filterInput.nativeElement.value = '';
    this.filterCtrl.setValue(null);
    //removing selected field from filter field options
    console.log("Filter Data here :",this.selectedFilterFields);
    this.onSearch.emit(this.selectedFilterFields);
    this.basicFilterForm.reset();
    this.mySelector= false;
  }

  add(event: MatChipInputEvent): void {
    // Add filter field only when MatAutocomplete is not open
    // To make sure this does not conflict with OptionSelected Event
    if (!this.matAutocomplete.isOpen) {
      const input = event.input;
      const value = event.value;

      // Add our filter field
      if ((value || '').trim()) {
        this.selectedDisplayFilterFields.push(value.trim());
      }

      // Reset the input value
      if (input) {
        input.value = '';
      }

      this.filterCtrl.setValue(null);
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
  field:IListColumn;
  selected(event: MatAutocompleteSelectedEvent): void {
    console.log("Selct Value Event :",event);
    //getting Icolumnfield object for selected field
    this.field = this.filterFields.find(x => x.label == event.option.viewValue);
    this.basicFilterForm.controls['fieldName'].setValue(this.field.column);
    this.compareValue(this.field);
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

  // campare value controller
  // field: IListColumn;
  filterFieldForm: FormGroup;
  operators: any;
  booleanOptions: string[] = ['True', 'False'];
  compareValue(val) {
    this.field = val;
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