# Fencepost
[![Gem Version](https://badge.fury.io/rb/fencepost.png)](http://badge.fury.io/rb/fencepost)
[![Build Status](https://travis-ci.org/scotthelm/fencepost.png)](https://travis-ci.org/scotthelm/fencepost)
[![Code Climate](https://codeclimate.com/github/scotthelm/fencepost.png)](https://codeclimate.com/github/scotthelm/fencepost)

For Rails 4.x - Provides a simple method for creating strong parameter
configuration based on your ActiveRecord models, and using this configuration
in your controllers.

## Installation

Add `fencepost` to your `Gemfile`

    gem 'fencepost'


## Configuration

    rails g fencepost_config

This creates a yaml map of your models. Here is where you can edit the allowable
attributes for your models. In the 80/20 rule, this would be the %80. Removing
attributes in the configuration yaml lets you set reasonable defaults for strong
parameter behavior.

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


