# Running The Webapp

## Webapp structure

The Django project resides in the [django/congressionaldata](../django/congressionaldata) folder of the repository.  It contains two Django apps:

* [api](../django/congressionaldata/api) is a JSON API server, which has mappings for the database tables in [models.py](../django/congressionaldata/api/models.py) and uses the Django Rest Framework to power the API (see [views.py](../django/congressionaldata/api/views.py) and [serializers.py](../django/congressionaldata/api/serializers.py)).
* [webapp](../django/congressionaldata/webapp) is a web application using React.js
and webpack. It pulls data from the API server and renders a visualization. It doesn't have any backend models, just a simple [HTML page](../django/congressionaldata/webapp/index.html) that
is the entry point for the application.

## Tutorials

### React

This tutorial is a great way to get started learning React and modern JavaScript
concepts: http://www.react.express.

### Django

If you'd like a refresher on Django, there's a good tutorial here:

https://docs.djangoproject.com/en/2.0/intro/tutorial01/

A few notes:
* For our app, we're not building models.py and running migration like the tutorial describes, because the data science team has set up the database with tables already created.  Instead, we produce a `models.py` that is reverse-engineered from the database schema using `python manage.py inspectdb`
* The tutorial goes into some depth on the templating language and views.  These are useful for traditional webapps.  Our visualization is probably going to be a [Single Page Application](https://en.wikipedia.org/wiki/Single-page_application) or SPA, which generally has simple, static HTML, but more complicated JavaScript that reads data from the API server and renders the page.

### Django REST Framework

Here's a tutorial on the Django REST Framework:

http://www.django-rest-framework.org/tutorial/1-serialization/

A few notes:
* This tutorial takes a somewhat longwinded approach by going through a bunch of lower-level views, before getting to the more concise `ViewSet`s and `Router`s that everyone ends up using in practice. So don't be discouraged if the first part of the tutorial doesn't seem to match anything you see in the repository.

## Running the webapp locally

1. Make sure your anaconda environment is activated, as described [here](02_development_environment.md#testing-python-installation)
2. Run the `export CD_DWH` command described [here](02_development_environment.md#verifying-your-development-environment)
3. From the `django/congressionaldata` folder, run `python manage.py runserver`
4. You should see output like this if everything went well:
```
Performing system checks...

System check identified no issues (0 silenced).

You have 14 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.

February 18, 2018 - 00:40:51
Django version 2.0.2, using settings 'congressionaldata.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

5. Open a different terminal from where the API is running to start the web
application and navigate to the `django/congressionaldata/webapp` directory.
6. If Yarn is not already installed, first do so following steps outlined
[here](https://yarnpkg.com/lang/en/docs/install/).
7. Install dependencies: `yarn install`
8. Build sources with webpack `yarn build:dev`
9. Run the development server: `yarn start_web:dev`. To use mock data, set
`NODE_ENV` to 'dev': `NODE_ENV=dev yarn start_web:dev`
10. Visit [http://127.0.0.1:8080/](http://127.0.0.1:8080/) in your browser to view the webapp.
11. You can also explore the API responses at [http://127.0.0.1:8000/api/models/](http://127.0.0.1:8000/api/models/).



| Previous | Next |
|:---------|-----:|
| [Developing Locally](./04_developing_locally.md) | [Domain Knowledge](./05_domain_knowledge.md)|
