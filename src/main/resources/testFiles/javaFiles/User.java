package com.nfin.testemaa.domain.model.Temp;

import java.util.*;
import javax.persistence.*;

/**
 * Auto-generated by:
 * org.apache.openjpa.jdbc.meta.ReverseMappingTool$AnnotatedCodeGenerator
 */
@Entity
@Table(schema="blog", name="user")
public class User {
	@OneToMany(targetEntity=com.nfin.testemaa.domain.model.Temp.Blog.class, mappedBy="user", cascade=CascadeType.MERGE)
	private Set blogs = new HashSet();

	@Basic
	@Column(name="email_address", nullable=false)
	private String emailAddress;

	@Basic
	@Column(name="first_name", nullable=false)
	private String firstName;

	@Basic
	@Column(name="last_name", nullable=false)
	private String lastName;

	@Basic
	@Column(nullable=false)
	private String password;

	@OneToMany(targetEntity=com.nfin.testemaa.domain.model.Temp.Subscription.class, mappedBy="user", cascade=CascadeType.MERGE)
	private Set subscriptions = new HashSet();

	@Id
	@Column(name="user_id", columnDefinition="bigserial")
	private long userId;

	@Basic
	@Column(name="user_name", nullable=false)
	private String userName;


	public User() {
	}

	public User(long userId) {
		this.userId = userId;
	}

	public Set getBlogs() {
		return blogs;
	}

	public void setBlogs(Set blogs) {
		this.blogs = blogs;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Set getSubscriptions() {
		return subscriptions;
	}

	public void setSubscriptions(Set subscriptions) {
		this.subscriptions = subscriptions;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}