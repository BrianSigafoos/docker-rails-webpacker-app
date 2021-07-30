module.exports = {
  '(app|config|lib|test|spec)/**/*.rb': (files) =>
    `bundle exec rubocop ${files.join(' ')}`,
  '**/*.html.erb': (files) => `bundle exec erblint ${files.join(' ')}`,
  'config/locales/**/*.yml': () => 'yarn i18n:fix',
  './**/*.md': ['prettier --write'],
  './**/*.js': ['prettier --write', 'eslint --fix'],
  './**/*.scss': ['prettier --write']
}
