# frozen_string_literal: true

# service to download dossier report and save them in common format

require 'tempfile'
require 'open-uri'
require 'roo'
require 'fileutils'

class ExportPiecesJointesEtatReel < ExportPiecesJointes
  include Utils

  def version
    super + 1
  end

  def required_fields
    super + %i[champ_dossier champ_mois]
  end

  private

  def run
    month_field = param_value(:champ_mois)
    return if month_field.nil?

    @year = month_field.primary_value
    @month = month_field.secondary_value

    @initial_dossier = nil

    super
  end

  def output_path(champ, filename)
    dir = ExportEtatNominatif.create_target_dir(self, initial_dossier)
    self.class.sanitize(@index, "#{champ} - #{filename}")
    index = report_index(@initial_dossier, @month)
    file = self.class.sanitize(@index, "#{champ} Mois #{index} - #{dossier.number} - #{@year}-#{@month} - #{filename}")
    "#{dir}/#{file}"
  end

  def initial_dossier
    if @initial_dossier.nil?
      initial_dossier_field = param_value(:champ_dossier)
      if initial_dossier_field.nil?
        throw "Impossible de trouver le dossier prévisionnel via le champ #{params[:champ_dossier]}"
      end

      @initial_dossier = initial_dossier_field.dossier
    end
    @initial_dossier
  end
end
