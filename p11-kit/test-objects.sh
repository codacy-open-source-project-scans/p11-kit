#!/bin/sh

test "${abs_top_builddir+set}" = set || {
	echo "set abs_top_builddir" 1>&2
	exit 1
}

. "$abs_top_builddir/common/test-init.sh"

setup() {
	testdir=$PWD/test-objects-$$
	test -d "$testdir" || mkdir "$testdir"
	cd "$testdir"
}

teardown() {
	rm -rf "$testdir"
}

test_list_all() {
	cat > list.exp <<EOF
Object: #0
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #1
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20Capitalize%20Key;type=public
    class: public-key
    label: Public Capitalize Key
Object: #2
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20prefix%20key;type=public
    class: public-key
    label: Public prefix key
Object: #3
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #4
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20Capitalize%20Key;type=public
    class: public-key
    label: Public Capitalize Key
Object: #5
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20prefix%20key;type=public
    class: public-key
    label: Public prefix key
Object: #6
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20CERTIFICATE;type=cert
    class: certificate
    certificate-type: x-509
    label: TEST CERTIFICATE
    flags:
          trusted
          copyable
          destroyable
Object: #7
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20PUBLIC%20KEY;type=public
    class: public-key
    key-type: ec
    label: TEST PUBLIC KEY
Object: #8
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #9
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20Capitalize%20Key;type=public
    class: public-key
    label: Public Capitalize Key
Object: #10
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20prefix%20key;type=public
    class: public-key
    label: Public prefix key
Object: #11
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #12
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20Capitalize%20Key;type=public
    class: public-key
    label: Public Capitalize Key
Object: #13
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Public%20prefix%20key;type=public
    class: public-key
    label: Public prefix key
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects -q "pkcs11:token=TEST%20LABEL" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains incorrect result"
	fi
}

test_list_with_type() {
	cat > list.exp <<EOF
Object: #0
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #1
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #2
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
Object: #3
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20LABEL;type=data
    class: data
    label: TEST LABEL
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects -q "pkcs11:token=TEST%20LABEL;type=data" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_list_private() {
	cat > list.exp <<EOF
Object: #0
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private
    class: private-key
    label: Private Capitalize Key
    flags:
          private
Object: #1
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private
    class: private-key
    label: Private Capitalize Key
    flags:
          private
Object: #2
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private
    class: private-key
    label: Private Capitalize Key
    flags:
          private
Object: #3
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private
    class: private-key
    label: Private Capitalize Key
    flags:
          private
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects --login -q "pkcs11:token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private?pin-value=booo" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_list_private_without_login() {
	cat > list.exp <<EOF
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects -q "pkcs11:token=TEST%20LABEL;object=Private%20Capitalize%20Key;type=private?pin-value=booo" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_list_exact() {
	cat > list.exp <<EOF
Object: #0
    uri: pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20CERTIFICATE;type=cert
    class: certificate
    certificate-type: x-509
    label: TEST CERTIFICATE
    flags:
          trusted
          copyable
          destroyable
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects -q "pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20CERTIFICATE;type=cert" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_list_nonexistent() {
	cat > list.exp <<EOF
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable list-objects -q "pkcs11:model=NONEXISTENT" > list.out; then
		assert_fail "unable to run: p11-kit list-objects"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_export_cert() {
	cat > list.exp <<EOF
-----BEGIN CERTIFICATE-----
MIIBajCCARSgAwIBAgICA+cwDQYJKoZIhvcNAQEFBQAwKDEmMCQGA1UEAxMdZmFy
LWluLXRoZS1mdXR1cmUuZXhhbXBsZS5jb20wIBcNMTMwMzI3MTY0OTMzWhgPMjA2
NzEyMjkxNjQ5MzNaMCgxJjAkBgNVBAMTHWZhci1pbi10aGUtZnV0dXJlLmV4YW1w
bGUuY29tMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOItNXB1wAdWQH1jvNJgs8+4
PSduEM1CUFGdeTB5WuPDUTiFTLSR2eaNaWrUnBxJwiUqySvy9I6KP4tMl8MWlpkC
AwEAAaMmMCQwIgYDVR0lBBswGQYIKwYBBQUHAwIGCCsGAQUFBwMEBgMqAwQwDQYJ
KoZIhvcNAQEFBQADQQDCgycygHRz4qOSqnzYUPRhULFjninvOB3AVSAPfukfoVQa
X4wmG2aWDmRSHACW+4F3ojodSQwD1RnyagEpMfv1
-----END CERTIFICATE-----
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable export-object -q "pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20CERTIFICATE;type=cert" > list.out; then
		assert_fail "unable to run: p11-kit export-object"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_export_pubkey() {
	cat > list.exp <<EOF
-----BEGIN PUBLIC KEY-----
MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEn1LlwLN/KBYQRVH6HfIMTzfEqJOVztLe
kLchp2hi78cCaMY81FBlYs8J9l7krc+M4aBeCGYFjba+hiXttJWPL7ydlE+5UG4U
Nkn3Eos8EiZByi9DVsyfy9eejh+8AXgp
-----END PUBLIC KEY-----
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable export-object -q "pkcs11:model=TEST%20MODEL;manufacturer=TEST%20MANUFACTURER;serial=TEST%20SERIAL;token=TEST%20LABEL;object=TEST%20PUBLIC%20KEY;type=public" > list.out; then
		assert_fail "unable to run: p11-kit export-object"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_generate_keypair() {
	cat > list.exp <<EOF
EOF

	if ! "$abs_top_builddir"/p11-kit/p11-kit-testable generate-keypair -q --type=mock "pkcs11:" > list.out; then
		assert_fail "unable to run: p11-kit generate-keypair"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
}

test_generate_keypair_nonexistent_token() {
	cat > list.exp <<EOF
EOF

	if "$abs_top_builddir"/p11-kit/p11-kit-testable generate-keypair --type=mock "pkcs11:token=NONEXISTENT" > list.out 2> err.out; then
		assert_fail "expected to fail: p11-kit generate-keypair"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
	assert_contains err.out "no matching token"
}

test_delete_nonexistent_token() {
	cat > list.exp <<EOF
EOF

	if "$abs_top_builddir"/p11-kit/p11-kit-testable delete-object "pkcs11:token=NONEXISTENT" > list.out 2> err.out; then
		assert_fail "expected to fail: p11-kit delete-object"
	fi

	: ${DIFF=diff}
	if ! ${DIFF} list.exp list.out > list.diff; then
		sed 's/^/# /' list.diff
		assert_fail "output contains wrong result"
	fi
	assert_contains err.out "no matching object"
}

run test_list_all test_list_with_type test_list_exact test_list_nonexistent \
    test_export_cert test_export_pubkey test_generate_keypair test_generate_keypair_nonexistent_token \
    test_delete_nonexistent_token \
    test_list_private test_list_private_without_login
