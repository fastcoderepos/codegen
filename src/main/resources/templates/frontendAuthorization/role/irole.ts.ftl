export interface IRole {  

      displayName: string;
      id: number;
      name: string;
      <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
			scimId: string;
			</#if>
  }
