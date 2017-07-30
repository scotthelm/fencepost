# Fencepost
[![Gem Version](https://badge.fury.io/rb/fencepost.png)](http://badge.fury.io/rb/fencepost)
[![Build Status](https://travis-ci.org/scotthelm/fencepost.png)](https://travis-ci.org/scotthelm/fencepost)
[![Code Climate](https://codeclimate.com/github/scotthelm/fencepost.png)](https://codeclimate.com/github/scotthelm/fencepost)
[![Coverage Status](https://coveralls.io/repos/scotthelm/fencepost/badge.png?branch=master)](https://coveralls.io/r/scotthelm/fencepost?branch=master)

For Rails 4.x - 5.x Provides a simple method for creating strong parameter
configuration based on your ActiveRecord models, and using this configuration
in your controllers.

## Installation

Add `fencepost` to your `Gemfile`

    gem 'fencepost'


## Configuration


    rails g fencepost_config

This creates a yaml map of your models in `config/fencepost.yml`.

You can re-run the initializer at any time. You will be asked if you want to
overwrite the existing config. "Y" will force an overwrite of the file, and you
will need to re-comment out any attributes you want to remove by default.

### Default Configuration

The yaml map is where you can edit the allowable attributes for your models. In
the 80/20 rule, this would be the %80. Removing attributes in the configuration
yaml lets you set reasonable defaults for strong parameter behavior.
This map is read one time during intialization and stored in the Fencepost
model graph (a class-level variable)

### Dev Mode

During the early stages of development where your code is in flux, you can set
`dev_mode=true` in `config/initializers/fencepost.rb`. dev mode will eager load
and read in all your models dynamically every time the class is instantiated.
(Ignoring the yaml in the initializer)

## Usage

The gem creates a `fencepost` method in your contollers. This returns a
`Fencepost` object that has read your models and given you access to strong
params for any ActiveRecord model in your application.

### Simplest Case

    # app/controllers/people_controller
    def create
      @person = Person.create(fencepost.person_params)
    end

### Simple allow / deny for top level model

In this example, the Person model allows height and weight by default, but does
NOT allow dob (date of birth). In this example we want to allow date of birth but
deny weight.

    # app/controllers/people_controller
    def create
      @person = Person.create(fencepost.allow(:dob).deny(:weight).person_params)
    end

### More complex allow / deny for nested models

In this example, the Person model has a collection of addresses. We want to
deny latitude and longitude from the acceptable attributes.

    # app/controllers/people_controller
    def create
      @person = Person.create(fencepost.deny(addresses_attributes: [:latitude, :longitude]).person_params)
    end

## Why?

I want to have an automatic way of generating strong parameters configuration
based on my models. I want to be able to set reasonable defaults for what is
accepted, but have the flexibility to account for edge cases.

### Where the idea came from
I was upgrading several applications from Rails 3.x and did not want to have to
write strong parameter declarations in all of my controllers. I got ruby to do
it for me.


