desc 'Generate Entity Relationship Diagram'
ERD_DISTDIR = './doc'

directory ERD_DISTDIR
task generate_erd: ERD_DISTDIR do
  system 'erd --inheritance --filetype=dot --direct --attributes=foreign_keys,content --polymorphism --notation=uml'
  system "dot -Tpng erd.dot > #{ERD_DISTDIR}/erd.png"
  system "dot -Tpdf erd.dot > #{ERD_DISTDIR}/erd.pdf"
  File.delete('erd.dot')
  Rake::Task['diagram:all'].invoke
  system "convert #{ERD_DISTDIR}/controllers_brief.svg #{ERD_DISTDIR}/controllers_brief.pdf"
  system "convert #{ERD_DISTDIR}/controllers_complete.svg #{ERD_DISTDIR}/controllers_complete.pdf"
  system "convert #{ERD_DISTDIR}/models_brief.svg #{ERD_DISTDIR}/models_brief.pdf"
  system "convert #{ERD_DISTDIR}/models_complete.svg #{ERD_DISTDIR}/models_complete.pdf"
end
