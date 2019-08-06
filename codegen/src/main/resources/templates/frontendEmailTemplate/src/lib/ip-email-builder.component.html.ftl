<div class="ip-email-builder" fxLayout="row-reverse">
  <div class="ip-email-builder-container" fxLayout="column" fxFlex>
    <mat-progress-bar *ngIf="generatingTemplate$ | async" mode="buffer"></mat-progress-bar>
    <div class="preview" fxLayoutGap="1rem" fxLayoutAlign="space-between center">

      <div fxFlexlayout fxLayoutGap="0.5rem">
        <!--  <button type="button" (click)="saveEmail()" [disabled]="previewTemplate" mat-stroked-button color="primary">Save
          Email</button>-->
        <button type="button" (click)="togglePreview()" [disabled]="!template" mat-stroked-button>
          <span *ngIf="!previewTemplate">{{'EMAIL-BUILDER.PREVIEW-BUTTON-TEXT' | translate}}</span>
          <span *ngIf="previewTemplate">{{'EMAIL-BUILDER.CLOSE-PREVIEW-BUTTON-TEXT' | translate}}</span>
        </button>
      </div>

      <ng-content fxLayout fxLayoutGap="0.5rem" select=".top-actions">

      </ng-content>

    </div>
    <ng-content fxLayout fxLayoutGap="0.5rem" select=".top-content">

    </ng-content>

    <ip-builder-container class="builder" *ngIf="!previewTemplate" fxLayout fxFlex fxLayoutAlign="center start"
      [ngStyle]="getBuilderContainerStyles()">
      <div class="builder-attached-elements email-body" fxLayout="column" fxLayoutAlign="center"
        [fxFlex]="getEmailWidth()">
        <smooth-dnd-container (drop)="onSegmentDrop($event)" lockAxis="y" groupName="structures"
          dragHandleSelector=".structure-move">

          <smooth-dnd-draggable *ngFor="let structure of email.structures; let key = index">
            <ip-structure [structure]="structure" [ngClass]="{active: (currentEditingStructure$ | async) === structure}"
              (blockClick)="editBlock($event)">
              <div class="tools" fxLayout fxLayoutGap="0.2em">
                <button mat-icon-button (click)="editStructure(structure)" color="primary"
                  matTooltip="{{'EMAIL-BUILDER.STRUCTURE.CHANGE-SETTING-TOOLTIP' | translate}}">
                  <mat-icon attr.aria-label="{{'EMAIL-BUILDER.STRUCTURE.CHANGE-SETTING-ARIA-LABEL' | translate}}">edit</mat-icon>
                </button>
                <button mat-icon-button *ngIf="email.structures.length > 1" class="structure-move"
                  matTooltip="{{'EMAIL-BUILDER.STRUCTURE.CHANGE-ORDER-TOOLTIP' | translate}}">
                  <mat-icon attr.aria-label="{{'EMAIL-BUILDER.STRUCTURE.CHANGE-ORDER-ARIA-LABEL' | translate}}">pan_tool</mat-icon>
                </button>
                <button mat-icon-button (click)="duplicateStructure(structure, key)" matTooltip="{{'EMAIL-BUILDER.STRUCTURE.DUPLICATE-TOOLTIP' | translate}}">
                  <mat-icon attr.aria-label="{{'EMAIL-BUILDER.STRUCTURE.DUPLICATE-ARIA-LABEL' | translate}}">file_copy</mat-icon>
                </button>
                <button mat-icon-button *ngIf="email.structures.length > 1" color="warn" (click)="removeStructure(key)"
                  matTooltip="{{'EMAIL-BUILDER.STRUCTURE.REMOVE-TOOLTIP' | translate}}">
                  <mat-icon attr.aria-label="{{'EMAIL-BUILDER.STRUCTURE.REMOVE-ARIA-LABEL' | translate}}">delete_forever</mat-icon>
                </button>
              </div>
            </ip-structure>
          </smooth-dnd-draggable>

          <!-- <div *ngIf="!email.structures.length" class="no-attached-elements" fxFlex="1 1 100%" fxLayout fxLayoutAlign="center center">
            Consider to add some structures from right side!
          </div> -->

        </smooth-dnd-container>
      </div>
    </ip-builder-container>

    <ip-preview-template fxLayout fxFlex="auto" fxLayoutAlign="center" *ngIf="previewTemplate" [template]="template">
    </ip-preview-template>

  </div>
  <div class="ip-email-builder-options" [ngClass]="{disabled: previewTemplate}" fxLayout="column" fxLayoutGap="1rem"
    fxFlex="0 0 calc(300px + 5%)">
    <div class="overflow"></div>
    <mat-tab-group [(selectedIndex)]="selectedTabIndex">
      <mat-tab label="{{'EMAIL-BUILDER.CONTENT.LABEL' | translate}}">
        <mat-expansion-panel>
          <mat-expansion-panel-header>
            <mat-panel-title>
              {{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.LABEL' | translate}}
            </mat-panel-title>
          </mat-expansion-panel-header>
          <smooth-dnd-container *ngIf="!(currentEditingStructure$ | async)" class="elements-lists" fxLayout="column"
            groupName="structures" [getChildPayload]="getStructurePayload()" behaviour="copy" dragClass="dragging"
            dropClass="dropped">
            <smooth-dnd-draggable *ngFor="let structure of structures">
              <div class="drag-element structure-element" [ngClass]="structure.type">
                <div *ngFor="let column of createArrayFromStructureColumns(structure)"></div>
              </div>
            </smooth-dnd-draggable>
            <ng-content fxLayout fxLayoutGap="0.5rem" select=".after-structure-blocks"></ng-content>
          </smooth-dnd-container>

          <div *ngIf="currentEditingStructure$ | async as structure" fxLayout="column">

            <div class="editing-element-header">
              <button type="button" (click)="editStructure(null)" mat-raised-button>
                <mat-icon attr.aria-label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.BACK-TO-STRUCTURE-ARIA-LABEL' | translate}}">arrow_back</mat-icon>
                <span class="title">{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.BACK-TO-STRUCTURE-BUTTON-TEXT' | translate}}</span>
              </button>
            </div>

            <div class="editing-element-options">
              <mat-form-field appearance="outline">
                <mat-label>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.BACKGROUND-IMAGE-LABEL' | translate}}</mat-label>
                <input matInput [(ngModel)]="structure.options.background.url" type="url"
                  placeholder="Background Image">
              </mat-form-field>
              <div class="group two">
                <ip-color [model]="structure.options.background" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.BACKGROUND-COLOR-LABEL' | translate}}"></ip-color>
                <ip-back-repeat [model]="structure.options.background"></ip-back-repeat>
                <!-- <ip-direction [model]="structure.options"></ip-direction> -->
              </div>
              <ip-width-height [model]="structure.options.background.size" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-SECTIONS.BACKGROUND-SIZE-LABEL' | translate}}"></ip-width-height>
              <ip-border [border]="structure.options.border"></ip-border>
              <ip-padding [padding]="structure.options.padding"></ip-padding>
            </div>

          </div>
        </mat-expansion-panel>
        <mat-expansion-panel>
          <mat-expansion-panel-header>
            <mat-panel-title>
              {{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.LABEL' | translate}}
            </mat-panel-title>
          </mat-expansion-panel-header>
          <mat-form-field>
            <p>{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.VARIABLE-NAME-LABEL' | translate}}:</p>
            <!--  <mat-select [(value)]="selected">-->
            <mat-select>
              <mat-option>{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.OPTIONS.NONE' | translate}}</mat-option>
              <mat-option value="option1">{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.OPTIONS.OPTION1' | translate}}</mat-option>
              <mat-option value="option2">{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.OPTIONS.OPTION2' | translate}}</mat-option>
              <mat-option value="option3">{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.OPTIONS.OPTION3' | translate}}</mat-option>
            </mat-select>
          </mat-form-field>
          <mat-form-field class="example-full-width">
            <input matInput placeholder="{{'EMAIL-BUILDER.CONTENT.VARIABLES-AND-TAGS.DEFAULT-VALUE' | translate}}" value="">
          </mat-form-field>
        </mat-expansion-panel>
        <mat-expansion-panel [expanded]="true">
          <mat-expansion-panel-header>
            <mat-panel-title>
              {{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.LABEL' | translate}}
            </mat-panel-title>
          </mat-expansion-panel-header>
          <smooth-dnd-container *ngIf="!(currentEditingBlock$ | async)?.type" class="elements-lists" fxLayout="column"
            groupName="blocks" [getChildPayload]="getBlockPayload()" behaviour="copy" dragClass="dragging"
            dropClass="dropped" nonDragAreaSelector=".disabled">
            <smooth-dnd-draggable *ngFor="let block of blocks">
              <div class="drag-element" [ngClass]="{disabled: block.state.disabled}" [matTooltip]="block.state.message">
                <mat-icon>{{block.icon}}</mat-icon>
                <div class="drag-element-title">{{block.type}}</div>
              </div>
            </smooth-dnd-draggable>
            <ng-content fxLayout fxLayoutGap="0.5rem" select=".after-content-blocks"></ng-content>
          </smooth-dnd-container>

          <div *ngIf="currentEditingBlock$ | async as block" fxLayout="column">

            <div class="editing-element-header">
              <button type="button" (click)="editBlock(null)" mat-raised-button>
                <mat-icon attr.aria-label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BACK-TO-CONTENT-ARIA-LABEL' | translate}}">arrow_back</mat-icon>
                <span class="title">{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BACK-TO-CONTENT-BUTTON-TEXT' | translate}}</span>
              </button>
            </div>

            <div class="editing-element-options">
              <ng-container *ngIf="block.type === 'text'">
                <ip-color [model]="block.options" key="color" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.TEXT.COLOR-LABEL' | translate}}"></ip-color>
                <ip-font-styles [font]="block.options.font"></ip-font-styles>
                <ip-line-height [lineHeight]="block.options.lineHeight"></ip-line-height>
                <ip-padding [padding]="block.options.padding"></ip-padding>
              </ng-container>

              <ng-container *ngIf="block.type === 'image'">
                <mat-form-field appearance="outline">
                  <mat-label>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.IMAGE.LABEL' | translate}}</mat-label>
                  <input matInput [(ngModel)]="block.src" type="url" placeholder="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.IMAGE.LABEL' | translate}}">
                </mat-form-field>
                <ip-width-height [model]="block.options.width" label="Width"></ip-width-height>
                <ip-width-height [model]="block.options.height" label="Height"></ip-width-height>
                <div class="group f-large">
                  <mat-form-field appearance="outline">
                    <mat-label>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.IMAGE.TITLE-LABEL' | translate}}</mat-label>
                    <input matInput [(ngModel)]="block.options.title" type="text" placeholder="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.IMAGE.TITLE-LABEL' | translate}}">
                  </mat-form-field>
                  <ip-align [model]="block.options"></ip-align>
                </div>
                <ip-link [link]="block.options.link"></ip-link>
                <ip-border [border]="block.options.border"></ip-border>
                <ip-padding [padding]="block.options.padding"></ip-padding>
              </ng-container>

              <ng-container *ngIf="block.type === 'button'">
                <mat-form-field appearance="outline">
                  <mat-label>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.LABEL' | translate}}</mat-label>
                  <input matInput [(ngModel)]="block.innerText" type="text" placeholder="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.LABEL' | translate}}">
                </mat-form-field>
                <div class="group three">
                  <ip-color [model]="block.options" key="color" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.COLOR-LABEL' | translate}}"></ip-color>
                  <ip-color [model]="block.options" key="backgroundColor" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.BACKGROUND-LABEL' | translate}}"></ip-color>
                  <ip-align [model]="block.options"></ip-align>
                </div>
                <ip-link [link]="block.options.link"></ip-link>
                <ip-line-height [lineHeight]="block.options.lineHeight"></ip-line-height>
                <ip-font-styles [(font)]="block.options.font"></ip-font-styles>
                <ip-border [border]="block.options.border"></ip-border>

                <h3 class="divider"><span>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.MARGIN-LABEL' | translate}}</span></h3>
                <ip-padding [padding]="block.options.padding"></ip-padding>

                <h3 class="divider"><span>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.BUTTON.PADDING-LABEL' | translate}}</span></h3>
                <ip-padding [padding]="block.options.innerPadding"></ip-padding>
              </ng-container>

              <ng-container *ngIf="block.type === 'divider'">
                <ip-border [border]="block.options.border"></ip-border>
                <ip-padding [padding]="block.options.padding"></ip-padding>
              </ng-container>

              <ng-container *ngIf="block.type === 'spacer'">
                <ip-width-height [model]="block.options.height" label="{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.SPACER.HEIGHT-LABEL' | translate}}"></ip-width-height>
              </ng-container>

              <ng-container *ngIf="block.type === 'social'">
                <p>{{'EMAIL-BUILDER.CONTENT.DRAG-AND-DROP-CONTENT.SOCIAL.MESSAGE' | translate}}</p>
              </ng-container>
            </div>

          </div>

        </mat-expansion-panel>

      </mat-tab>

      <mat-tab label="{{'EMAIL-BUILDER.SETTINGS.LABEL' | translate}}">
        <div class="editing-element-options">
          <ip-width-height [model]="email.general.width" label="{{'EMAIL-BUILDER.SETTINGS.WIDTH-LABEL' | translate}}"></ip-width-height>
          <!-- <div class="group f-large">
            <mat-form-field appearance="outline">
              <mat-label>Background Image</mat-label>
              <input matInput [(ngModel)]="email.general.background.url" type="url" placeholder="Background Image">
            </mat-form-field>
            <ip-back-repeat [model]="email.general.background"></ip-back-repeat>
          </div> -->
          <div class="group two">
            <ip-color [model]="email.general.background" label="{{'EMAIL-BUILDER.SETTINGS.BACKGROUND-COLOR-LABEL' | translate}}"></ip-color>
            <ip-direction [model]="email.general"></ip-direction>
          </div>
          <!-- <ip-width-height [model]="email.general.background.size" label="Background Size"></ip-width-height> -->
          <ip-padding [padding]="email.general.padding"></ip-padding>

          <h3 class="divider"><span>{{'EMAIL-BUILDER.SETTINGS.GLOBAL-PADDING-LABEL' | translate}}</span></h3>
          <ip-padding [padding]="email.general.global.padding"></ip-padding>

        </div>
      </mat-tab>
    </mat-tab-group>
  </div>
</div>