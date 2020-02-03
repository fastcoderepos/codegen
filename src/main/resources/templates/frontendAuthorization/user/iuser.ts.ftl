export interface IUser {  

      accessFailedCount?: number;
      authenticationSource?: string;
      emailAddress: string;
      emailConfirmationCode?: string;
      firstName: string;
      id: number;
      isActive?: boolean;
      isEmailConfirmed?: boolean;
      isLockoutEnabled?: boolean;
      isPhoneNumberConfirmed?: string;
      lastLoginTime?: Date;
      lastName: string;
      lockoutEndDateUtc?: Date;
      password?: string;
      passwordResetCode?: string;
      phoneNumber?: string;
      profilePictureId?: number;
      twoFactorEnabled?: boolean;
      userName: string;
			<#if AuthenticationType == "oidc">
			scimId: string;
			</#if>
  }
