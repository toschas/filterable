# Filterable

Filterable is a ruby gem providing easy filtering of Active Record objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filterable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filterable

## Usage

### Defining filters
Filterable provides `filter_by` method to ActiveRecord Objects which lets you define attributes to be filtered by:

```ruby
class Post < ActiveRecord::Base
  filter_by :active, :published
end
```

### Filtering objects

```ruby
User.filter(by_active: true, by_user_type: 'customer') # returns users where active is true and user type is equal to 'customer'
```
Method is available on an AR Collection and it returns an AR collection so it can be chained with other methods.

```ruby
User.where('email LIKE ?', '%@example.com').filter(by_active: true, by_user_type: 'customer')
```
or
```ruby
User.filter(by_active: true, by_user_type: 'customer').where('email LIKE ?', '%@example.com')
```

### Using in Controller (Rails)
You can just pass params hash to `filter` method. It will ignore keys that are not defined in the model by default.
The right way (more secure) would be using strong params so you control what can be passed to filter.

```ruby
class UsersController < ApplicationController
    def index
        @users = Users.filter(filter_params)
    end
    
    protected
    
    def filter_params
        params.permit(:by_active, :by_user_type)
    end
end
```

### Range Filters
For comparable types of fields (numeric values, date or datetime) `from` and `to` filters are also generated
```ruby
class User < ActiveRecord::Base
    filter_by :registered_on, :tasks_assigned
end
```
Presuming that 'registered_on' is a date and 'tasks_assigned' is an integer, the following filters will be available:

 - by_registered_on (attribute value is equal to the value passed)
 - from_registered_on (attribute value is greather than the value passed)
 - to_registered_on (attribute value is smaller than the value passed)
 
 and the same for 'tasks_assigned' attribute. So for example: 

```ruby
User.filter(from_tasks_assigned: 2) # returns users with more than 2 tasks assigned
User.filter(to_registered_on: Date.today) # retuns users registered before today
```

### Filter by related model attribute
Filtering by attributes of another model is possible with `joins` option.
**Names of joined models follow the same pattern as when defining relations: singular for 'belongs_to' and 'has_one', and plural for 'has_many'.
Filters must also be named accordingly: `:user_email, joins: :user` and `:tasks_title, joins: :tasks`**

```ruby
class Task < ActiveRecord::Base
    belongs_to :user
    filter_by :user_email, joins: :user 
end

class User < ActiveRecord::Base
    has_many :tasks
    filter_by :tasks_title, joins: :tasks
end
```

```ruby
User.filter(by_tasks_title: 'test') # returns users where task title is 'test'
Task.filter(by_user_email: 'test@example.com') # returns tasks where user email is 'test@example.com'
```


Filtering through two or more related models works the same way, `joins` options must be specified the same way as passing it to `.joins()` method.
So if you want to filter `Company` by task title and you need to join tasks through users, format the option the same way you would tell ActiveRecord
how to join the tables, and name the filter accordingly.

```ruby
class Company < ActiveRecord::Base
    has_many :users
    filter_by :users_tasks_title, joins: { users: :tasks }
end
```

then

```ruby
Company.filter(by_user_tasks_title: 'test')
```

### Custom Filters
By passing `custom: true` option an empty custom filter will be defined. It can than be overridden with a scope or a class method.

```ruby
class Task < ActiveRecord::Base
    filter_by :fuzzy_title, custom: true # generates empty by_fuzzy_title filter
    
    # Overiding the filter with a class method or a scope
    scope :by_fuzzy_title, ->(title) { where('title LIKE ?', "%#{title}%") }
end
```

By default `by_` prefix will be used. It can be changed by passing an option

```ruby
filter_by :fuzzy_title, custom: true, prefix: :where # generates where_fuzzy_title filter
filter_by :custom_filter, custom: true, prefix: [:by, :recent] # generates by_custom_filter and recent_custom_filter filters
```

**`joins` option is ignored if `custom: true` is passed**
**`prefix` option is ignored if `custom: true` is not passed**

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

