export enum listColumnType {
  String = "String",
  Number = "Number",
  Date = "Date",
  Boolean = "Boolean"
}
export interface IListColumn {
  column: string,
  label: string,
  sort: boolean,
  filter: boolean,
  type: listColumnType,
  options?: Array<any>
}