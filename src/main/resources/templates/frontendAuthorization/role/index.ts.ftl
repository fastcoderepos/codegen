export { RoleListComponent } from './role-list.component';
export { RoleDetailsComponent } from './role-details.component';
<#if !ExcludeRoleNew>
export { RoleNewComponent } from './role-new.component';
</#if>
export { IRole } from './irole';
export { RoleService } from './role.service';
