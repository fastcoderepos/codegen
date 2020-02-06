package [=PackageName].application.authorization.user;

import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchFields;
import [=CommonModulePackage].search.SearchUtils;
import [=PackageName].application.authorization.user.dto.*;
import [=PackageName].domain.authorization.user.IUserManager;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.model.QUserEntity;
import com.querydsl.core.BooleanBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
<#if Cache!false>
import org.springframework.cache.annotation.*;
</#if>
import org.apache.commons.lang3.StringUtils;
import java.util.*;

@Service
@Validated
public class UserAppService implements IUserAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private IUserManager _userManager;

	@Autowired
	private UserMapper mapper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreateUserOutput Create(CreateUserInput input) {

		UserEntity user = mapper.CreateUserInputToUserEntity(input);		
		UserEntity createdUser = _userManager.Create(user);
		
		return mapper.UserEntityToCreateUserOutput(createdUser);
	}

	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache!false>
	@CacheEvict(value="User", key = "#p0")
	</#if>
	public UpdateUserOutput Update(Long userId, UpdateUserInput input) {

		UserEntity user = mapper.UpdateUserInputToUserEntity(input);
		UserEntity updatedUser = _userManager.Update(user);
		return mapper.UserEntityToUpdateUserOutput(updatedUser);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache!false>
	@CacheEvict(value="User", key = "#p0")
    </#if>
	public void Delete(Long userId) {

		UserEntity existing = _userManager.FindById(userId) ; 
		_userManager.Delete(existing);
	
	}

	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache!false>
	@Cacheable(value = "User", key = "#p0")
	</#if>
	public FindUserByIdOutput FindById(Long userId) {

		UserEntity foundUser = _userManager.FindById(userId);
		if (foundUser == null)  
			return null ; 
 	   
 	   FindUserByIdOutput output=mapper.UserEntityToFindUserByIdOutput(foundUser); 
		return output;
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache!false>
	@Cacheable(value = "User", key = "#p0")
	</#if>
	public FindUserByNameOutput FindByUserName(String userName) {

		UserEntity foundUser = _userManager.FindByUserName(userName);
		if (foundUser == null) {
			return null;
		}
		return  mapper.UserEntityToFindUserByNameOutput(foundUser);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache!false>
	@Cacheable(value = "User", key = "#p0")
	</#if>
	public FindUserWithAllFieldsByIdOutput FindWithAllFieldsById(Long userId) {

		UserEntity foundUser = _userManager.FindById(userId);
		if (foundUser == null)  
			return null ; 
 	   
 	    FindUserWithAllFieldsByIdOutput output=mapper.UserEntityToFindUserWithAllFieldsByIdOutput(foundUser); 
		return output;
	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache!false>
	@Cacheable(value = "User")
	</#if>
	public List<FindUserByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<UserEntity> foundUser = _userManager.FindAll(Search(search), pageable);
		List<UserEntity> userList = foundUser.getContent();
		Iterator<UserEntity> userIterator = userList.iterator(); 
		List<FindUserByIdOutput> output = new ArrayList<>();

		while (userIterator.hasNext()) {
			output.add(mapper.UserEntityToFindUserByIdOutput(userIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QUserEntity user= QUserEntity.userEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(user, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(user,keysList,search.getValue(),search.getOperator());
			}
			else if(search.getType()==case3)
			{
				Map<String,SearchFields> map = new HashMap<>();
				for(SearchFields fieldDetails: search.getFields())
				{
					map.put(fieldDetails.getFieldName(),fieldDetails);
				}
				List<String> keysList = new ArrayList<String>(map.keySet());
				checkProperties(keysList);
				return searchKeyValuePair(user, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QUserEntity user,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(user.authenticationSource.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.emailAddress.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.emailConfirmationCode.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.firstName.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.isPhoneNumberConfirmed.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.lastName.likeIgnoreCase("%"+ value + "%"));
			<#if AuthenticationType == "database">
			builder.or(user.password.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.passwordResetCode.likeIgnoreCase("%"+ value + "%"));
			</#if>
			builder.or(user.phoneNumber.likeIgnoreCase("%"+ value + "%"));
			builder.or(user.userName.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(user.authenticationSource.eq(value));
        	builder.or(user.emailAddress.eq(value));
        	builder.or(user.emailConfirmationCode.eq(value));
        	builder.or(user.firstName.eq(value));
        	builder.or(user.isPhoneNumberConfirmed.eq(value));
        	builder.or(user.lastName.eq(value));
        	<#if AuthenticationType == "database">
        	builder.or(user.password.eq(value));
        	builder.or(user.passwordResetCode.eq(value));
        	</#if>
        	builder.or(user.phoneNumber.eq(value));
        	builder.or(user.userName.eq(value));
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
        		<#if AuthenticationType == "database">
		    	builder.or(user.isActive.eq(Boolean.parseBoolean(value)));
		    	</#if>	
		    	builder.or(user.isEmailConfirmed.eq(Boolean.parseBoolean(value)));
		    	builder.or(user.isLockoutEnabled.eq(Boolean.parseBoolean(value)));
		    	builder.or(user.isTwoFactorEnabled.eq(Boolean.parseBoolean(value)));
       	 	}
			else if(StringUtils.isNumeric(value)){
                builder.or(user.accessFailedCount.eq(Integer.valueOf(value)));
				builder.or(user.profilePictureId.eq(Long.valueOf(value)));
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
	        	builder.or(user.lastLoginTime.eq(SearchUtils.stringToDate(value)));
	        	builder.or(user.lockoutEndDateUtc.eq(SearchUtils.stringToDate(value)));
			}
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		 list.get(i).replace("%20","").trim().equals("roleId") ||
		
		 list.get(i).replace("%20","").trim().equals("accessFailedCount") ||
		 list.get(i).replace("%20","").trim().equals("authenticationSource") ||
		 list.get(i).replace("%20","").trim().equals("emailAddress") ||
		 list.get(i).replace("%20","").trim().equals("emailConfirmationCode") ||
		 list.get(i).replace("%20","").trim().equals("firstName") ||
		 list.get(i).replace("%20","").trim().equals("id") ||
		 list.get(i).replace("%20","").trim().equals("isEmailConfirmed") ||
		 list.get(i).replace("%20","").trim().equals("isLockoutEnabled") ||
		 list.get(i).replace("%20","").trim().equals("isPhoneNumberConfirmed") ||
		 list.get(i).replace("%20","").trim().equals("lastLoginTime") ||
		 list.get(i).replace("%20","").trim().equals("lastName") ||
		 list.get(i).replace("%20","").trim().equals("lockoutEndDateUtc") ||
		 <#if AuthenticationType == "database">
		 list.get(i).replace("%20","").trim().equals("isActive") ||
		 list.get(i).replace("%20","").trim().equals("password") ||
		 list.get(i).replace("%20","").trim().equals("passwordResetCode") ||
		 </#if>
		 list.get(i).replace("%20","").trim().equals("phoneNumber") ||
		 list.get(i).replace("%20","").trim().equals("profilePictureId") ||
		 list.get(i).replace("%20","").trim().equals("userrole") ||
		 list.get(i).replace("%20","").trim().equals("isTwoFactorEnabled") ||
		 list.get(i).replace("%20","").trim().equals("userName") ||
		 list.get(i).replace("%20","").trim().equals("userpermission")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QUserEntity user,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
			if(list.get(i).replace("%20","").trim().equals("accessFailedCount")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or(user.accessFailedCount.eq(Integer.valueOf(value)));
			}
            if(list.get(i).replace("%20","").trim().equals("authenticationSource")) {
				if(operator.equals("contains"))
					builder.or(user.authenticationSource.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.authenticationSource.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("emailAddress")) {
				if(operator.equals("contains"))
					builder.or(user.emailAddress.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.emailAddress.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("emailConfirmationCode")) {
				if(operator.equals("contains"))
					builder.or(user.emailConfirmationCode.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.emailConfirmationCode.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("firstName")) {
				if(operator.equals("contains"))
					builder.or(user.firstName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.firstName.eq(value));
			}
			if(list.get(i).replace("%20","").trim().equals("isEmailConfirmed")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or(user.isEmailConfirmed.eq(Boolean.parseBoolean(value)));
			}
			if(list.get(i).replace("%20","").trim().equals("isLockoutEnabled")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or(user.isLockoutEnabled.eq(Boolean.parseBoolean(value)));
			}
            if(list.get(i).replace("%20","").trim().equals("isPhoneNumberConfirmed")) {
				if(operator.equals("contains"))
					builder.or(user.isPhoneNumberConfirmed.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.isPhoneNumberConfirmed.eq(value));
			}
			if(list.get(i).replace("%20","").trim().equals("lastLoginTime")) {
				if(operator.equals("equals") && SearchUtils.stringToDate(value)!=null)
					builder.or(user.lastLoginTime.eq(SearchUtils.stringToDate(value)));
			}
            if(list.get(i).replace("%20","").trim().equals("lastName")) {
				if(operator.equals("contains"))
					builder.or(user.lastName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.lastName.eq(value));
			}
			if(list.get(i).replace("%20","").trim().equals("lockoutEndDateUtc")) {
				if(operator.equals("equals") && SearchUtils.stringToDate(value)!=null)
					builder.or(user.lockoutEndDateUtc.eq(SearchUtils.stringToDate(value)));
			}
			<#if AuthenticationType == "database">
			if(list.get(i).replace("%20","").trim().equals("isActive")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or(user.isActive.eq(Boolean.parseBoolean(value)));
			}
            if(list.get(i).replace("%20","").trim().equals("password")) {
				if(operator.equals("contains"))
					builder.or(user.password.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.password.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("passwordResetCode")) {
				if(operator.equals("contains"))
					builder.or(user.passwordResetCode.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.passwordResetCode.eq(value));
			}
			</#if>
            if(list.get(i).replace("%20","").trim().equals("phoneNumber")) {
				if(operator.equals("contains"))
					builder.or(user.phoneNumber.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.phoneNumber.eq(value));
			}
			if(list.get(i).replace("%20","").trim().equals("profilePictureId")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or(user.profilePictureId.eq(Long.valueOf(value)));
			}
			if(list.get(i).replace("%20","").trim().equals("isTwoFactorEnabled")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or(user.isTwoFactorEnabled.eq(Boolean.parseBoolean(value)));
			}
            if(list.get(i).replace("%20","").trim().equals("userName")) {
				if(operator.equals("contains"))
					builder.or(user.userName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(user.userName.eq(value));
			}
		 
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QUserEntity user, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
			if(details.getKey().replace("%20","").trim().equals("accessFailedCount")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and(user.accessFailedCount.eq(Integer.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and(user.accessFailedCount.ne(Integer.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and(user.accessFailedCount.between(Integer.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and(user.accessFailedCount.goe(Integer.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and(user.accessFailedCount.loe(Integer.valueOf(details.getValue().getEndingValue())));
				}
			}
            if(details.getKey().replace("%20","").trim().equals("authenticationSource")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.authenticationSource.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.authenticationSource.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.authenticationSource.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("emailAddress")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.emailAddress.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.emailAddress.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.emailAddress.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("emailConfirmationCode")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.emailConfirmationCode.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.emailConfirmationCode.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.emailConfirmationCode.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("firstName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.firstName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.firstName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.firstName.ne(details.getValue().getSearchValue()));
			}
			if(details.getKey().replace("%20","").trim().equals("isEmailConfirmed")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isEmailConfirmed.eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isEmailConfirmed.ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
			if(details.getKey().replace("%20","").trim().equals("isLockoutEnabled")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isLockoutEnabled.eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isLockoutEnabled.ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
            if(details.getKey().replace("%20","").trim().equals("isPhoneNumberConfirmed")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.isPhoneNumberConfirmed.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.isPhoneNumberConfirmed.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.isPhoneNumberConfirmed.ne(details.getValue().getSearchValue()));
			}
			if(details.getKey().replace("%20","").trim().equals("lastLoginTime")) {
				if(details.getValue().getOperator().equals("equals") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and(user.lastLoginTime.eq(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and(user.lastLoginTime.ne(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   Date startDate= SearchUtils.stringToDate(details.getValue().getStartingValue());
				   Date endDate= SearchUtils.stringToDate(details.getValue().getEndingValue());
				   if(startDate!=null && endDate!=null)	 
					   builder.and(user.lastLoginTime.between(startDate,endDate));
				   else if(endDate!=null)
					   builder.and(user.lastLoginTime.loe(endDate));
                   else if(startDate!=null)
                	   builder.and(user.lastLoginTime.goe(startDate));  
                 }
                   
			}
            if(details.getKey().replace("%20","").trim().equals("lastName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.lastName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.lastName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.lastName.ne(details.getValue().getSearchValue()));
			}
			if(details.getKey().replace("%20","").trim().equals("lockoutEndDateUtc")) {
				if(details.getValue().getOperator().equals("equals") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and(user.lockoutEndDateUtc.eq(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and(user.lockoutEndDateUtc.ne(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   Date startDate= SearchUtils.stringToDate(details.getValue().getStartingValue());
				   Date endDate= SearchUtils.stringToDate(details.getValue().getEndingValue());
				   if(startDate!=null && endDate!=null)	 
					   builder.and(user.lockoutEndDateUtc.between(startDate,endDate));
				   else if(endDate!=null)
					   builder.and(user.lockoutEndDateUtc.loe(endDate));
                   else if(startDate!=null)
                	   builder.and(user.lockoutEndDateUtc.goe(startDate));  
                 }
                   
			}
			<#if AuthenticationType == "database">
			if(details.getKey().replace("%20","").trim().equals("isActive")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isActive.eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isActive.ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
            if(details.getKey().replace("%20","").trim().equals("password")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.password.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.password.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.password.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("passwordResetCode")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.passwordResetCode.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.passwordResetCode.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.passwordResetCode.ne(details.getValue().getSearchValue()));
			}
			</#if>
            if(details.getKey().replace("%20","").trim().equals("phoneNumber")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.phoneNumber.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.phoneNumber.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.phoneNumber.ne(details.getValue().getSearchValue()));
			}
			if(details.getKey().replace("%20","").trim().equals("profilePictureId")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and(user.profilePictureId.eq(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and(user.profilePictureId.ne(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and(user.profilePictureId.between(Long.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and(user.profilePictureId.goe(Long.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and(user.profilePictureId.loe(Long.valueOf(details.getValue().getEndingValue())));
				}
			}
			if(details.getKey().replace("%20","").trim().equals("isTwoFactorEnabled")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isTwoFactorEnabled.eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and(user.isTwoFactorEnabled.ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
            if(details.getKey().replace("%20","").trim().equals("userName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(user.userName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(user.userName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(user.userName.ne(details.getValue().getSearchValue()));
			}
		}
	
		return builder;
	}
	
	public Map<String,String> parseUserpermissionJoinColumn(String keysString) {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("userId", keysString);
		return joinColumnMap;
	}
	
	public Map<String,String> parseUserroleJoinColumn(String keysString) {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("userId", keysString);
		return joinColumnMap;
		
	}

}

