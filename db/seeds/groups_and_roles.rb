######################
# CREACION DE GRUPOS #
######################
admin_puntospoint = Burlesque::Group.find_or_create_by_name(Settings.admin_puntospoint)

admin_efi         = Burlesque::Group.find_or_create_by_name(Settings.admin_efi)
operator_efi     = Burlesque::Group.find_or_create_by_name(Settings.operator_efi)

admin_eco         = Burlesque::Group.find_or_create_by_name(Settings.admin_eco)
operator_eco      = Burlesque::Group.find_or_create_by_name(Settings.operator_eco)


######################
# CREACION DE ROLES  #
######################
r1  = Burlesque::Role.find_or_create_by_name('admin#manage')
r2  = Burlesque::Role.find_or_create_by_name('category#manage')
r3  = Burlesque::Role.find_or_create_by_name('efi#manage')
r4  = Burlesque::Role.find_or_create_by_name('industry#manage')
r5  = Burlesque::Role.find_or_create_by_name('user_efi#manage')
r6  = Burlesque::Role.find_or_create_by_name('eco#manage')
r7  = Burlesque::Role.find_or_create_by_name('experience#manage')
r8  = Burlesque::Role.find_or_create_by_name('user_eco#manage')
r9  = Burlesque::Role.find_or_create_by_name('event#manage')

r11 = Burlesque::Role.find_or_create_by_name('user_efi#update')
r12 = Burlesque::Role.find_or_create_by_name('experience#read')
r13 = Burlesque::Role.find_or_create_by_name('event#read')
r14 = Burlesque::Role.find_or_create_by_name('create#read')
r15 = Burlesque::Role.find_or_create_by_name('account#manage')
r16 = Burlesque::Role.find_or_create_by_name('transaction#create')
r17 = Burlesque::Role.find_or_create_by_name('banner#manage')
r18 = Burlesque::Role.find_or_create_by_name('publicity#manage')

r19 = Burlesque::Role.find_or_create_by_name('user_eco#update')
r20 = r7  # Burlesque::Role.find_or_create_by_name('experience#manage')
r21 = r18 # Burlesque::Role.find_or_create_by_name('publicity#manage')
r22 = Burlesque::Role.find_or_create_by_name('experience#read')
r23 = Burlesque::Role.find_or_create_by_name('purchase#validate')
r24 = Burlesque::Role.find_or_create_by_name('purchase#read')
r25 = Burlesque::Role.find_or_create_by_name('incomes#read')

r26 = Burlesque::Role.find_or_create_by_name('support#index')
r27 = Burlesque::Role.find_or_create_by_name('support#show')


######################
# ROLES Y GRUPOS     #
######################
admin_puntospoint.push_roles [r1, r2, r3, r4, r5, r6, r7, r8, r9]

admin_efi.push_roles [r11, r12, r13, r14, r15, r16, r17, r18]
operator_efi.push_roles [r11, r26, r27]

admin_eco.push_roles [r19, r20, r21, r22, r23, r24, r25]
operator_eco.push_roles [r22, r23, r24]
