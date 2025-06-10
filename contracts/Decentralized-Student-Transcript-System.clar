;; Decentralized Student Transcript System
;; Issue and retrieve student transcripts securely on-chain

(define-constant err-not-issuer (err u100))
(define-constant err-transcript-exists (err u101))
(define-constant err-transcript-not-found (err u102))

;; Contract owner (issuer)
(define-constant issuer tx-sender)

;; Store transcripts: map student principal to transcript hash (e.g., IPFS hash)
(define-map transcripts principal (buff 32))

;; Issue a transcript (only issuer)
(define-public (issue-transcript (student principal) (transcript-hash (buff 32)))
  (begin
    (asserts! (is-eq tx-sender issuer) err-not-issuer)
    (asserts! (is-none (map-get? transcripts student)) err-transcript-exists)
    (map-set transcripts student transcript-hash)
    (ok true)
  )
)

;; Get transcript hash by student principal
(define-read-only (get-transcript (student principal))
  (match (map-get? transcripts student)
    transcript-hash (ok (some transcript-hash))
    (ok none)
  )
)