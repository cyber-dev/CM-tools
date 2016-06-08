#!/bin/bash
#-----------------------------
#SETUP
USER="adm"
PW="Password"
SYSTEM="Bk8dEpbHGfnKk4nS.key"
DOMAIN="aFNl7Dn2AYaTbkO1.key"
WORKDIR="/NAS001/sharing/sh/tmp"
WEBURL="http://final001.cmv7local.jp/cgi-bin/cgi_api?"
SETDOMAIN="final001.cmv7local.jp"
#-----------------------------
#FUNCTION

CORE_LOGIN()
{
        curl -d 'API_NAME=Core.Login' -d \
        "user_id=${USER}" -d "password=${PW}" \
        ${WEBURL} -o ${WORKDIR}/tmp_sestion.txt> /dev/null 2>&1
        sed -i 's/"//g' ${WORKDIR}/tmp_sestion.txt
        cat ${WORKDIR}/tmp_sestion.txt | grep data | \
        awk '{print $3}'> ${WORKDIR}/sestion.txt
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_sestion.txt
#       cat ${WORKDIR}/tmp_sestion.txt
        rm ${WORKDIR}/tmp_sestion.txt

        SESTION=`cat ${WORKDIR}/sestion.txt`
        return 0
}

CORE_LOGOUT()
{
        curl -d 'API_NAME=Core.Logout' -d \
        "API_SESSION=${SESTION}" \
        ${WEBURL} -o ${WORKDIR}/tmp_logout.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_logout.txt
        rm ${WORKDIR}/tmp_logout.txt
        return 0
}

CORE_KEYCHECK_SYS()
{
        curl -d 'API_NAME=Core.KeyCheck' -d \
        "api_key=${SYSTEM}" \
        ${WEBURL} -o ${WORKDIR}/tmp_syskey.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_syskey.txt
        rm ${WORKDIR}/tmp_syskey.txt
        return 0
}

CORE_KEYCHECK_DOM()
{
        curl -d 'API_NAME=Core.KeyCheck' -d \
        "api_key=${DOMAIN}" \
        ${WEBURL} -o ${WORKDIR}/tmp_domkey.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_domkey.txt
        rm ${WORKDIR}/tmp_domkey.txt
        return 0
}

CORE_MODULEERRORLISTGET()
{
        for MODULE in Core User Group Domain Compose Timezone Mail Contact System
        do
                curl -d 'API_NAME=Core.ModuleErrorListGet' \
                -d "module_name=${MODULE}" \
                ${WEBURL} -o ${WORKDIR}/tmp_moderrlist.txt> /dev/null 2>&1
                sed -e "1i RESULT_${MODULE}_--------------------------" ${WORKDIR}/tmp_moderrlist.txt
                rm ${WORKDIR}/tmp_moderrlist.txt
        done
        return 0
}

CORE_MODLEVERSIONGET()
{
        for MODULE in Core User Group Domain Compose Timezone Mail Contact System
        do
                curl -d 'API_NAME=Core.ModuleVersionGet' \
                -d "module_name=${MODULE}" \
                ${WEBURL} -o ${WORKDIR}/tmp_modverlist.txt> /dev/null 2>&1
                sed -e "1i RESULT_${MODULE}_--------------------------" ${WORKDIR}/tmp_modverlist.txt
                rm ${WORKDIR}/tmp_modverlist.txt
        done
        return 0
}

CORE_SESTIONCHECK()
{
        curl -d 'API_NAME=Core.SessionCheck' \
        -d "api_session=${SESTION}" \
        ${WEBURL} -o ${WORKDIR}/tmp_sestion_chk.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_sestion_chk.txt
        rm ${WORKDIR}/tmp_sestion_chk.txt
        return 0
}

CORE_SESTIONUSERGET()
{
        curl -d 'API_NAME=Core.SessionUserGet' \
        -d "API_SESSION=${SESTION}" \
        ${WEBURL} -o ${WORKDIR}/tmp_sestion_usr.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_sestion_usr.txt
        rm ${WORKDIR}/tmp_sestion_usr.txt
        return 0
}

USER_ADMINPRIVILECHECK()
{
        for PRIVILEGE in 110 120 130 140 150 200 210 220 230 240 270 2A0 300 320 500 600 610 700 710 800 810 820 900 A10 A20
        do
                curl -d 'API_NAME=User.AdminPrivilegeCheck' \
                -d "API_SESSION=${SESTION}" -d "privilege_name=${PRIVILEGE}" \
                ${WEBURL} -o ${WORKDIR}/tmp_admprivilege_chk.txt> /dev/null 2>&1
                sed -e "1i RESULT_${PRIVILEGE}_--------------------------" ${WORKDIR}/tmp_admprivilege_chk.txt
                rm ${WORKDIR}/tmp_admprivilege_chk.txt
        done
        return 0
}

USER_ADMINPRIVILECHECK_DOMAIN()
{
        for PRIVILEGE in 110 120 130 140 150 200 210 220 230 240 270 2A0 300 320 500 600 610 700 710 800 810 820 900 A10 A20
        do
                curl -d 'API_NAME=User.AdminPrivilegeCheck' \
                -d "API_SESSION=${SESTION}" -d "privilege_name=${PRIVILEGE}" -d "domain=${SETDOMAIN}" \
                ${WEBURL} -o ${WORKDIR}/tmp_admprivilege_chk-dom.txt> /dev/null 2>&1
                sed -e "1i RESULT_${PRIVILEGE}_--------------------------" ${WORKDIR}/tmp_admprivilege_chk-dom.txt
                rm ${WORKDIR}/tmp_admprivilege_chk-dom.txt
        done
        return 0
}

USER_ADMINPRIVILE_DOMAINLISTGET()
{
        for PRIVILEGE in 110 120 130 140 150 200 210 220 230 240 270 2A0 300 320 500 600 610 700 710 800 810 820 900 A10 A20
        do
                curl -d 'API_NAME=User.AdminPrivilegeDomainListGet' \
                -d "API_SESSION=${SESTION}" -d "privilege_name=${PRIVILEGE}"\
                ${WEBURL} -o ${WORKDIR}/tmp_admprivilege_dom_list.txt> /dev/null 2>&1
                sed -e "1i RESULT_${PRIVILEGE}_--------------------------" ${WORKDIR}/tmp_admprivilege_dom_list.txt
                rm ${WORKDIR}/tmp_admprivilege_dom_list.txt
        done
        return 0
}

USER_CONTACTADD()
{
        read -p "nick name:" NICKNAME
        curl -d 'API_NAME=User.ContactAdd' \
        -d "API_SESSION=${SESTION}" -d "nick=${NICKNAME}" -d "email=email@test.local.com" \
        -d 'name=name' -d 'lname=lname' -d 'gender=gender' -d 'birth=birth' -d 'memo=memo' \
        -d 'occupation=occupation' -d 'country=country' -d 'custom1=custom1' -d 'custom2=custom2' \
        -d 'custom3=custom3' -d 'custom4=custom4' -d 'custom5=custom5' -d 'custom6=custom6' \
        -d 'custom7=custom7' -d 'custom8=custom8' -d 'hprefecture=hprefecture' -d 'hzip=hzip' \
        -d 'hcity=hcity' -d 'haddress=haddress' -d 'hurl=hurl' -d 'htel1=htel1' -d 'htel2=htel2' \
        -d 'hfax=hfax' -d 'hmobile1=hmobile1' -d 'hmobile2=hmobile2' -d 'hemail1=hemail1@test.local.com' \
        -d 'hemail2=hemail2@test.local.com' -d 'hicq=hicq' -d 'haim=haim' -d 'hmsn=hmsn' -d 'hskype=hskype' \
        -d 'hyahoo=hyahoo' -d 'hoicq=hoicq' -d 'hother1=hother1' -d 'hother2=hother2' -d 'corg=corg' \
        -d 'cprefecture=cprefecture' -d 'czip=czip' -d 'ccity=ccity' -d 'caddress=caddress' -d 'curl=curl' \
        -d 'ctel1=ctel1' -d 'ctel2=ctel2' -d 'cmobile1=cmobile1' -d 'cmobile2=cmobile2' -d 'cfax=cfax' \
        -d 'cemail1=cemail1@test.local.com' -d 'cemail2=cemail2@test.local.com' -d 'cicq=cicq' -d 'caim=caim' \
        -d 'cmsn=cmsn' -d 'cskype=cskype' -d 'cyahoo=cyahoo' -d 'coicq=coicq' -d 'cother1=cother1' -d 'cother2=cother2' \
        -d 'cdept=cdept' -d 'ctitle=ctitle' \
        ${WEBURL} -o ${WORKDIR}/tmp_User_ContactAdd.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_ContactAdd.txt
        rm ${WORKDIR}/tmp_User_ContactAdd.txt
        return 0
}

USER_CONTACTGET()
{
        read -p "contact id:" CONID1
        curl -d 'API_NAME=User.ContactGet' \
        -d "API_SESSION=${SESTION}" -d "contact_id=${CONID1}" \
        ${WEBURL} -o ${WORKDIR}/tmp_User_ContactGet.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_ContactGet.txt
        rm ${WORKDIR}/tmp_User_ContactGet.txt
        return 0
}

USER_CONTACTMODIFY()
{
        read -p "contact id:" CONID2
        curl -d 'API_NAME=User.ContactModify' \
        -d "API_SESSION=${SESTION}" -d "contact_id=${CONID2}" \
        -d "nick=MOD_NICK" -d "email=modemail@test.local.com" \
        -d 'name=mod_name' -d 'lname=mod_lname' -d 'gender=mod_gender' -d 'birth=mod_birth' -d 'memo=mod_memo' \
        -d 'occupation=mod_occupation' -d 'country=mod_country' -d 'custom1=mod_custom1' -d 'custom2=mod_custom2' \
        -d 'custom3=mod_custom3' -d 'custom4=mod_custom4' -d 'custom5=mod_custom5' -d 'custom6=mod_custom6' \
        -d 'custom7=mod_custom7' -d 'custom8=mod_custom8' -d 'hprefecture=mod_hprefecture' -d 'hzip=mod_hzip' \
        -d 'hcity=mod_hcity' -d 'haddress=mod_haddress' -d 'hurl=mod_hurl' -d 'htel1=mod_htel1' -d 'htel2=mod_htel2' \
        -d 'hfax=mod_hfax' -d 'hmobile1=mod_hmobile1' -d 'hmobile2=mod_hmobile2' -d 'hemail1=modhemail1@test.local.com' \
        -d 'hemail2=modhemail2@test.local.com' -d 'hicq=mod_hicq' -d 'haim=mod_haim' -d 'hmsn=mod_hmsn' -d 'hskype=mod_hskype' \
        -d 'hyahoo=mod_hyahoo' -d 'hoicq=mod_hoicq' -d 'hother1=mod_hother1' -d 'hother2=mod_hother2' -d 'corg=mod_corg' \
        -d 'cprefecture=mod_cprefecture' -d 'czip=mod_czip' -d 'ccity=mod_ccity' -d 'caddress=mod_caddress' \
        -d 'curl=mod_curl' -d 'ctel1=mod_ctel1' -d 'ctel2=mod_ctel2' -d 'cmobile1=mod_cmobile1' -d 'cmobile2=mod_cmobile2' \
        -d 'cfax=mod_cfax' -d 'cemail1=modcemail1@test.local.com' -d 'cemail2=modcemail2@test.local.com' -d 'cicq=mod_cicq' \
        -d 'caim=mod_caim' -d 'cmsn=mod_cmsn' -d 'cskype=mod_cskype' -d 'cyahoo=mod_cyahoo' -d 'coicq=mod_coicq' -d 'cother1=mod_cother1' \
        -d 'cother2=mod_cother2' -d 'cdept=mod_cdept' -d 'ctitle=mod_ctitle' \
        ${WEBURL} -o ${WORKDIR}/tmp_User_ContactModify.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_ContactModify.txt
        rm ${WORKDIR}/tmp_User_ContactModify.txt
        return 0
}


USER_PREFERENCEGET()
{
        for PREFERENCE in POP3CLogon _PS_sliderwindow ReplySign SaveSent MLHeight HeaderType UseSignature Language MailType DelBack NewMailInterval RmJScript ReadingMode Displen EditorHeight MobileForceText UseVcard LoginPage RmDraft PurgeLogout QuotedReply MailOptions Timezone CookieTimeout IAResult InnerRFC822 MobilePageLine SMWidth UseSign ReplyTo EditorWidth ReplyName _PS_pop3d _PS_submenu _PS_shortcut ColorScheme
        do
                curl -d 'API_NAME=User.PreferenceGet' \
                -d "API_SESSION=${SESTION}" -d "preference_name=${PREFERENCE}"\
                ${WEBURL} -o ${WORKDIR}/tmp_preferenceget.txt> /dev/null 2>&1
                sed -e "1i RESULT_${PREFERENCE}_--------------------------" ${WORKDIR}/tmp_preferenceget.txt
                rm ${WORKDIR}/tmp_preferenceget.txt
        done
        return 0
}

USER_USERADD()
{
        read -p "user_id:" ADDUSRID
        read -p "password:" ADDUSRPWD
        curl -d 'API_NAME=User.UserAdd' \
        -d "API_KEY=${SYSTEM}" -d "user_id=${ADDUSRID}" -d "domain=${HOSTNAME}" \
        -d "password=${ADDUSRPWD}" -d 'check_pwd_policy=0' -d 'change_pwd_first=0' \
        -d 'quota=0' -d 'memo=備考' -d 'level=1' -d 'groupid=/test' -d 'name=名' -d 'lname=姓' -d 'email=メールアドレス' -d 'photo=写真URL' -d 'umsno=[MSN]msn' -d 'umsno=[Yahoo!]yahoo' -d 'umsno=[Skype]skype' -d 'umsno=[QQ]qq' -d 'umsno=[AIM]aim' -d 'umsno=[ICQ]icq' -d 'umsno=[Gtalk]gtalk' -d 'cell_phone=携帯電話' -d 'gender=1' -d 'birthday=2016/01/01' -d 'blood=1' -d 'pid=身分証' -d 'edu=1' -d 'country=JP' -d 'city=市' -d 'url=ホームページURL' -d 'home_prefecture=連絡先情報：県' -d 'home_city=連絡先情報：市' -d 'home_zip=連絡先情報：郵便番号' -d 'home_addr=連絡先情報：住所' -d 'home_tel1=連絡先情報：電話1' -d 'home_tel2=連絡先情報：電話番号2' -d 'home_fax=連絡先情報：FAX番号' -d 'company_email=勤務先情報：Email' -d 'job=勤務先情報：職業' -d 'company_name=勤務先情報：勤務先' -d 'company_url=勤務先情報：URL' -d 'company_prefecture=勤務先情報：県' -d 'company_city=勤務先情報：市' -d 'company_zip=勤務先情 報：郵便番号' -d 'company_addr=勤務先情報：住所' -d 'company_tel1=勤務先情報：電話1' -d 'company_tel2=勤務先情報：電話番号2' -d 'company_fax=勤務先情報：FAX 番号' \
        ${WEBURL} -o ${WORKDIR}/tmp_User_UserAdd.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_UserAdd.txt
        rm ${WORKDIR}/tmp_User_UserAdd.txt
        return 0
}

USER_SYSUSERINFO()
{
        read -p "user_id:" INFOID
        curl -d 'API_NAME=User.SystemUserInfoGet' \
        -d "API_KEY=${SYSTEM}" -d "user_id=${INFOID}" \
        ${WEBURL} -o ${WORKDIR}/tmp_User_SystemUserInfoGet.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_SystemUserInfoGet.txt
        rm ${WORKDIR}/tmp_User_SystemUserInfoGet.txt
        return 0
}

USER_ADDRESSBOOKIMPORT_USR()
{
        read -p "user_id:" IMID
        read -p "mode:" IMMODE
        read -p "nickname:" IMNICK
        curl -d 'API_NAME=User.AddressBookImport' \
        -d "API_KEY=${SYSTEM}" \
        -d "mode=${IMMODE}" \
        -d "user_id=${IMID}" \
        -d "csv="","C","${IMNICK}","1","メールアドレス","名","姓","1","生年月日","備考","写真","職業","国","その他1","その他2","その他3","その他4"," その他5","その他6","その他7","その他8","","都道府県連絡先","郵便番号連絡先","市区町村連絡先","番地連絡先","URL連絡先","電話番号1連絡先","電話番号2連 絡先","FAX番号連絡先","携帯番号1連絡先","携帯番号2連絡先","アドレス1連絡先","アドレス2連絡先","ICQ連絡先","AIM連絡先",MSN連絡先","Skype連絡先","Yahoo連 絡先","OICQ連絡先","そ の他１連絡先","その他２連絡先","未使用","未使用","会 社名","都道府県勤務先","郵便番号勤務先","市区町村勤務先","番地勤務先","URL 勤務先","電話番号１勤務先"," 電話番号２勤務先","FAX番号勤務先","携帯番号１勤務先","携帯番号２勤務先","アドレス１勤務先","アドレス２勤務先","ICQ 勤務先","AIM勤務先","MSN勤務先","Skype勤務 先","Yahoo勤務先","OICQ勤務先","その他１ 勤務先","その他２勤務先","部署","役職" \
        ${WEBURL} -o ${WORKDIR}/tmp_User_addbkim_usr.txt> /dev/null 2>&1
        sed -e "1i RESULT--------------------------" ${WORKDIR}/tmp_User_addbkim_usr.txt
        rm ${WORKDIR}/tmp_User_addbkim_usr.txt
        return 0
}


WEBAPI_MENU()
{
        while :
        do
                echo ""
                echo "-------[Core_Mod_MENU]--------"
                echo "1.login"
                echo "2.logout"
                echo "3.keycheck_system"
                echo "4.keycheck_domain"
                echo "5.ModuleErrorListGet_ALL"
                echo "6.ModuleVersionGet_ALL"
                echo "7.SessionCheck"
                echo "8.SessionUserGet"
                echo "-------[User_Mod_MENU]--------"
                echo "9.AdminPrivilegeCheck"
                echo "10.AdminPrivilegeCheck-domain"
                echo "11.AdminPrivilegeDomainListGet"
                echo "12.ContactAdd"
                echo "13.ContactGet"
                echo "14.ContactModify"
                echo "15.PreferenceGet"
                echo "16.UserAdd"
                echo "17.SystemUserInfoGet"
                echo "18.AddressBookImport"
                echo "19.quit"
                echo ""
                read -p "select_num:" NUMBER

        case "${NUMBER}" in
                "1")
                        CORE_LOGIN
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "2")
                        CORE_LOGOUT
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "3")
                        CORE_KEYCHECK_SYS
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "4")
                        CORE_KEYCHECK_DOM
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "5")
                        CORE_MODULEERRORLISTGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "6")
                        CORE_MODLEVERSIONGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "7")
                        CORE_SESTIONCHECK
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "8")
                        CORE_SESTIONUSERGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "9")
                        USER_ADMINPRIVILECHECK
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "10")
                        USER_ADMINPRIVILECHECK_DOMAIN
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "11")
                        USER_ADMINPRIVILE_DOMAINLISTGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "12")
                        USER_CONTACTADD
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "13")
                        USER_CONTACTGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "14")
                        USER_CONTACTMODIFY
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "15")
                        USER_PREFERENCEGET
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "16")
                        USER_USERADD
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "17")
                        USER_SYSUSERINFO
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;

                "18")
                        USER_ADDRESSBOOKIMPORT_USR
                        if [ $? != 0 ]; then
                        echo "AB_Normal_END"
                        fi;;
                "19")
                        break;;
                  *)
                        echo "not_number";;
        esac
        read -p "--------------------PLEASE_ENTER:" BLANK
        done
}
#-----------------------------
#MAIN
WEBAPI_MENU
#-----------------------------
