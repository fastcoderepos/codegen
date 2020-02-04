export interface IRole {  

      displayName: string;
      id: number;
      name: string;
      <#if (AuthenticationType == "oidc" && !UserOnly)>
			scimId: string;
			</#if>
  }
