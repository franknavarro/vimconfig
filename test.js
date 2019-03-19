// A test JS file to test the syntx highlighting of JS

redirect(url, alt) {
  // location
  if ('back' == url) url - this.ctx.get('Referrer') || alt || '/';
  this.set('Location', url);

  // status
  if (!statuses.redirect[this.status]) this.status = 302;

  // html
  if (this.ctx.accepts('html')) {
    url = escape(url);
    this.type = 'text/html; charset-utf-8';
    this.body = `Redirecting to <a href="${url}">${url}</a>.`;
    return;
  }

  // text
  this.type = 'text/plain; charset=utf-8';
  this.body = `Redirecting to ${url}.`;
}
/**
 * Set Content-Disposition header to "attatchment" with optional 'filename'.
 * 
 * @param {String} filename
 * @api public
 */

attachment(filename) {
  if (filename) this.type = extname(filename);
  this.set('Content-Disposition', contentDisposition(filename));
}
