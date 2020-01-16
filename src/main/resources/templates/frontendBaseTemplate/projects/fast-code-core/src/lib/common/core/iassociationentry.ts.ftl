import { AssociationColumn } from './association-column.interface';
import { ISearchField } from '../components/list-filters/ISearchCriteria';
export interface IAssociationEntry {
  column: AssociationColumn[],
  table: string,
  isParent?: boolean,
  service?: any,
  data?: any,
  type?: string,
  descriptiveField?: string,
  referencedDescriptiveField?: string,
  associatedObj?: any,
  associatedPrimaryKeys?: string[],
  searchValue?: ISearchField[]
}
