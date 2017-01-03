module I18nHelper

  def self.name_for_locale(locale)
    I18n.with_locale(locale) { I18n.translate("i18n.language.name") }
  rescue I18n::MissingTranslationData
    locale.to_s
  end

end