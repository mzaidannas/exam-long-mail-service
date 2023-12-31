class AccessPolicy
  include AccessGranted::Policy

  def configure
    # Example policy for AccessGranted.
    # For more details check the README at
    #
    # https://github.com/chaps-io/access-granted/blob/master/README.md
    #
    # Roles inherit from less important roles, so:
    # - :admin has permissions defined in :member, :guest and himself
    # - :member has permissions from :guest and himself
    # - :guest has only its own permissions since it's the first role.
    #
    # The most important role should be at the top.
    # In this case an administrator.
    #
    role :operator, proc { |user| user.operator? } do
      can :create, Train
      can :list, Train
      can %i[read update destroy], Train do |train, user|
        train.user_id == user.id
      end
      can :read, Parcel do |parcel, user|
        user.trains.pluck(:id).include?(parcel.train_id)
      end
    end

    role :owner, proc { |user| user.owner? } do
      can :create, Parcel
      can :list, Parcel
      can %i[read update destroy], Parcel do |parcel, user|
        parcel.user_id == user.id
      end
    end

    role :postmaster, proc { |user| user.postmaster? } do
      can :manage, Booking
      can :list, Train
      can :update, Train
    end

    # More privileged role, applies to registered users.
    #
    # role :member, proc { |user| user.registered? } do
    #   can :create, Post
    #   can :create, Comment
    #   can [:update, :destroy], Post do |post, user|
    #     post.author == user
    #   end
    # end

    # The base role with no additional conditions.
    # Applies to every user.
    #
    # role :guest do
    #  can :read, Post
    #  can :read, Comment
    # end
  end
end
