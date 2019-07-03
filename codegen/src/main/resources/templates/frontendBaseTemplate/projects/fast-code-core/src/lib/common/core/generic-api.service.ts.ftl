import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { ISearchField, operatorType, ISearchCriteria } from '../../common/components/list-filters/ISearchCriteria';
import { ServiceUtils } from '../utils/serviceUtils';

import { IP_CONFIG } from '../../tokens';
import { IForRootConf } from '../../IForRootConf';

@Injectable()
export class GenericApiService<T> {
  private url = "";
  private apiUrl = "";
  private suffix = '';
  constructor(private http: HttpClient,  private config: IForRootConf, suffix: string) {
    this.apiUrl = config.apiUrl;
    this.url = config.apiUrl + '/' + suffix;
    this.suffix = suffix;
  }

  public getAll(searchFields?: ISearchField[], offset?: number, limit?: number, sort?: string): Observable<T[]> {

    let params = ServiceUtils.buildQueryData(searchFields, offset, limit, sort);

    return this.http.get<T[]>(this.url, { params }).pipe(map((response: any) => {
      return response;
    }), catchError(this.handleError));

  }
  getAssociations(parentSuffix: string, parentId: any, searchFields?: ISearchField[], offset?: number, limit?: number, sort?: string): Observable<T[]> {

    let url = this.apiUrl + '/' + parentSuffix + '/' + parentId + '/' + this.suffix;
    let params = ServiceUtils.buildQueryData(searchFields, offset, limit, sort);
    return this.http.get<T[]>(url, { params }).pipe(map((response: any) => {
      return response;
    }), catchError(this.handleError));
  }

  public getById(id: any): Observable<T> {
    return this.http
      .get<T>(this.url + '/' + id).pipe(catchError(this.handleError));
  }
  public create(item: T): Observable<T> {
    return this.http
      .post<T>(this.url, item).pipe(catchError(this.handleError));

  }
  public update(item: T, id: any): Observable<T> {
    return this.http
      .put<T>(this.url + '/' + id, item).pipe(catchError(this.handleError));
  }
  public delete(id: any): Observable<null> {
    return this.http
      .delete(this.url + '/' + id).pipe(map(res => null), catchError(this.handleError));
  }
  public deleteAssociation(parentSuffix: string, parentId: any, id: any): Observable<null> {
    let url = this.apiUrl + '/' + parentSuffix + '/' + parentId + '/' + this.suffix
    return this.http
      .delete(url + '/' + id).pipe(map(res => null), catchError(this.handleError));
  }
  public addAssociation(parentSuffix: string, parentId: any, item: any): Observable<null> {
    let url = this.apiUrl + '/' + parentSuffix + '/' + parentId + '/' + this.suffix
    return this.http
      .post(url, item).pipe(map(res => null), catchError(this.handleError));
  }

  protected handleError(err: HttpErrorResponse) {

    let errorMessage = '';
    if (err.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      errorMessage = 'An error occurred: ' + err.error.message;
    } else {

      errorMessage = 'Server returned code: ' + err.status + ', error message is: ' + err.message;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
}