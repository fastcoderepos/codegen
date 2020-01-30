<div class="table-container" (onScroll)="onTableScroll()" appVirtualScroll>
    <mat-table matSort [dataSource]="items" class="mat-elevation-z8">
        <ng-container matColumnDef="Parent">
            <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Parent')"> Parent
            </mat-header-cell>
            <mat-cell *matCellDef="let item">
                {{ item.parentDescriptiveField }}
            </mat-cell>
        </ng-container>
        <ng-container matColumnDef="id">
            <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('id')"> id
            </mat-header-cell>
            <mat-cell *matCellDef="let item">
                {{ item.id }}
            </mat-cell>
        </ng-container>
        <ng-container matColumnDef="name">
            <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('name')"> name
            </mat-header-cell>
            <mat-cell *matCellDef="let item">
                {{ item.name }}
            </mat-cell>
        </ng-container>
        <ng-container matColumnDef="actions">
            <mat-header-cell *matHeaderCellDef> Actions</mat-header-cell>
            <mat-cell *matCellDef="let item" (click)="$event.stopPropagation()">
                <button mat-button color="accent"
                    (click)="delete(item)">{{'GENERAL.ACTIONS.DELETE' | translate }}</button>
            </mat-cell>
        </ng-container>
        <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
        <mat-row *matRowDef="let row; columns: displayedColumns;" (click)="openDetails(row)"></mat-row>
    </mat-table>
</div>