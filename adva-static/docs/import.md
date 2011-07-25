# Adva::Static Import

Turns a directory structure into Site, Page, Blog, Post, ... models by
detecting path structure patterns.

This structure would expand to a site with two sections. A blog "Home" which is
the root section (i.e. on "/") and a page "Contact" (on "/contact").

    import/
      2010-10-10-post.yml
      contact.yml
      index.yml

This would expand to a page "Home" on "/", a blog "Blog" on "/blog" and a page
"Contact" on '/contact'

    import/
      blog/
        2010-10-10-post.yml
      blog.yml
      contact.yml
      index.yml

The blog metadata file can also be omitted. So, these directory structures
would result in the same page structures as above:

    import/
      2010-10-10-post.yml
      contact.yml

    import/
      blog/
        2010-10-10-post.yml
      contact.yml

Files named `import/contact.yml` and `import/contact/index.yml` are equivalent.
The former will be used first. So these directory structures would result in
the same page structures as above:

    import/
      2010-10-10-post.yml
      contact/
        index.yml
      index.yml

    import/
      blog/
        2010-10-10-post.yml
        index.yml
      contact/
        index.yml
      index.yml


## Sources

Source classes are used to detect path structure patterns and turn path names
and file contents into a nested hash.

* Source::Path is just a helper class for finding Paths that match a pattern.
  It can represent a file or directory.
* Source::Site takes a directory, detects and reads a site.yml and detects and
  initializes Source::Section sources.
* Source::Section sources read their respective source file (if it exists) and
  detect and initialize content and category sources (if that applies for the
  section type).
* Site, Section, Post and Category sources respond to :data which returns a
  nested hash of attributes

E.g. with a directory structure

    import/site.yml
    import/about.md

`Source::Site.new('import')` will find the `site.yml` file and read it.

`Source::Site.new('import').sections` return an array containing an instance of
`Source::Page` which is initialized with the path `import/about.md`.

With the directory structure

    import/2010/10-10-hello-world.md

`Source::Site.new('import').sections` will return an array with a
`Source::Blog` pointing to `import`.

With the directory structure

    import/blog/2010/10-10-hello-world.md

`Source::Site.new('import').sections` will return an array with a
`Source::Blog` pointing to `import/blog`.

`Source::Site.new('import').data` will return a Data::Blog `"blog"` with a
hash holding the attributes given in `10-10-hello-world.md`

With the directory structure

    import/support/blog/2010/10-10-hello-world.md

`Source::Site.new('import').sections` will return an array with a
`Source::Page` pointing to `import/support` and a `Source::Blog` pointing to
`import/support/blog`.


## Models

Model classes take Source classes and turn them into actual adva-cms2 model
instances.
