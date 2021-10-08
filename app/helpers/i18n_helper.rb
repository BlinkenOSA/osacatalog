module I18nHelper

  def self.translate(locale, field)
    begin
      I18n.with_locale(locale) do
        I18n.translate(field, :raise => I18n::MissingTranslationData)
      end
    rescue I18n::MissingTranslationData
      I18n.with_locale('en') { I18n.translate(field) }
    end
  end

end