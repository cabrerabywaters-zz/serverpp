# encoding: utf-8

# Public: Proporciona los métodos "can" para la definición y
#         control de las habilidades de los usuarios.
#
# @public Ability initialize(user, context) Constructor de la clase
#
#
# Mas información en: https://github.com/ryanb/cancan
#
class Ability
  # Modulo que permite cargar las habilidades de los usuarios.
  # Mas información en: https://github.com/ryanb/cancan/blob/master/lib/cancan/ability.rb
  include CanCan::Ability

  # Internal: Constructor de la clase.
  #           Entrega una instancia de la clase Ability
  #           con las habilidades del usuario en el contexto dado
  #
  # @parametros:
  # User    user       -  El Usuario del cual se quiere obtener las habilidades.
  # Symbol  context    -  El contexto en el que esta trabajando el usuario.
  #                       Las opciones validas son: [:puntos_point, :efi, :eco],
  #                       en cualquier otro caso el usuario queda sin habilidades.
  #
  # Ejemplo
  #
  #   Ability.new @user, :puntos_point
  #   # => #<Ability:0x007fa1df66cf28 @rules=[.........]>
  #
  # Retorna una instancia de Ability.
  def initialize(user, context)
    if user
      if context == :puntos_point
        can :manage, Admin
        can :manage, Category
        can :manage, Efi
        can :manage, Industry
        can :manage, Interest
        can :manage, UserEfi
        can :manage, Eco
        can :manage, Experience
        can :manage, UserEco
        can :manage, Event

      elsif context == :efi
        can :update, UserEfi,    id: user.id
        can :read,   Experience
        can :read,   Event
        can :create, Event
        can :publish, Event
        can :unpublish, Event
        can :manage, Account
        can :create, Transaction
        can :manage, Banner,    event: {efi_id: user.efi_id}
        can :manage, Publicity, event: {efi_id: user.efi_id}

        if user.group?(Settings.admin_efi)
          can :support, :index
          can :support, :show          
        end
        
        if user.group?(Settings.operator_efi)
          can :support, :index
          can :support, :show
          cannot :update, UserEfi
        end

      elsif context == :eco
        can :validate, Experience, eco_id: user.eco_id

        user.roles.each do |role|
          action = role.action_sym
          model  = role.resource_class

          if model == UserEco
            can action, model, id: user.id
          elsif model == Experience
            if action == :manage && user.eco.present? && user.eco.bigger
              can action, Experience, eco_id: user.eco_id
            elsif action != :manage
              can action, Experience, eco_id: user.eco_id
            end
          elsif model == Publicity
            can action, model, event: {experience: {eco_id: user.eco_id}}
          elsif model == Purchase
            can action, model, exchange: {event: {experience: {eco_id: user.eco_id}}}
          else
            can action, model
          end
        end
        # can :update, UserEco,    id: user.id
        # can :manage, Experience, eco_id: user.eco_id
        # can :manage, Publicity,  event: {experience: {eco_id: user.eco_id}}

        # # Para validar
        # can :read,     Experience, eco_id: user.eco_id
        # can :read,     Purchase,   exchange: {event: {experience: {eco_id: user.eco_id}}}
        # can :validate, Purchase,   exchange: {event: {experience: {eco_id: user.eco_id}}}
      end
    end
  end
end
