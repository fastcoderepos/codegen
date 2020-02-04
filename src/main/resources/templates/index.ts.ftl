export { [=ClassName]ListComponent } from './[=ModuleName]-list.component';
export { [=ClassName]DetailsComponent } from './[=ModuleName]-details.component';
<#if !ExcludeUserNew>
export { [=ClassName]NewComponent } from './[=ModuleName]-new.component';
</#if>

export { [=IEntity] } from './i[=ModuleName]';
export { [=ClassName]Service } from './[=ModuleName].service';
