# kate: syntax python
"""
Declarations for all C++ classes that are wrapped from Cython.
"""
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector
from libc.stdint cimport uint32_t


cdef extern from "../src/read.h":
	cdef cppclass Read:
		Read(string, int, int, int, int, string) except +
		Read(Read) except +
		string toString() except +
		void addVariant(int, int, int) except +
		string getName() except +
		vector[int] getMapqs() except +
		void addMapq(int) except +
		int getPosition(int) except +
		void setPosition(int, int)  except +
		int getAllele(int) except +
		void setAllele(int, int) except +
		int getVariantQuality(int) except +
		void setVariantQuality(int, int) except +
		int getVariantCount() except +
		void sortVariants() except +
		bool isSorted() except +
		int getSourceID() except +
		int getSampleID() except +
		int getReferenceStart() except +
		string getBXTag() except +
		bool hasBXTag() except +


cdef extern from "../src/indexset.h":
	cdef cppclass IndexSet:
		IndexSet() except +
		bool contains(int) except +
		void add(int) except +
		int size() except +
		string toString() except +


cdef extern from "../src/readset.h":
	cdef cppclass ReadSet:
		ReadSet() except +
		void add(Read*) except +
		string toString() except +
		int size() except +
		void sort() except +
		Read* get(int) except +
		Read* getByName(string, int) except +
		ReadSet* subset(IndexSet*) except +
		# TODO: Check why adding "except +" here doesn't compile
		vector[unsigned int]* get_positions()


cdef extern from "../src/pedigree.h":
	cdef cppclass Pedigree:
		Pedigree() except +
		void addIndividual(unsigned int id, vector[Genotype*] genotypes, vector[PhredGenotypeLikelihoods*]) except +
		void addRelationship(unsigned int f, unsigned int m, unsigned int c) except +
		unsigned int size()
		string toString() except +
		const Genotype* get_genotype_by_id(unsigned int, unsigned int) except +
		const PhredGenotypeLikelihoods* get_genotype_likelihoods_by_id(unsigned int, unsigned int) except +
		unsigned int get_variant_count() except +
		unsigned int triple_count() except +


cdef extern from "../src/pedigreedptable.h":
	cdef cppclass PedigreeDPTable:
		PedigreeDPTable(ReadSet*, vector[unsigned int], Pedigree* pedigree, bool distrust_genotypes, vector[unsigned int]* positions) except +
		void get_super_reads(vector[ReadSet*]*, vector[unsigned int]* transmission_vector) except +
		int get_optimal_score() except +
		vector[bool]* get_optimal_partitioning()
		
		
cdef extern from "../src/binomial.h":
	cdef int binomial_coefficient(int n, int k) except +
		
		
cdef extern from "../src/genotype.h":
	cdef cppclass Genotype:
		Genotype() except +
		Genotype(vector[uint32_t] alleles) except +
		#Genotype(uint32_t index, uint32_t ploidy) except +
		Genotype(Genotype genotype) except +
		vector[uint32_t] as_vector() except +
		bool is_none() except +
		uint32_t get_index() except +
		uint32_t get_ploidy() except +
		string toString() except +
		bool is_homozygous() except +
		bool is_diploid_and_biallelic() except +
	cdef bool operator==(Genotype,Genotype) except +
	cdef bool operator!=(Genotype,Genotype) except +
	cdef bool operator<(Genotype,Genotype) except +


cdef extern from "../src/genotypedptable.h":
	cdef cppclass GenotypeDPTable:
		GenotypeDPTable(ReadSet*, vector[unsigned int], Pedigree* pedigree, vector[unsigned int]* positions) except +
		vector[long double] get_genotype_likelihoods(unsigned int individual, unsigned int position) except +

cdef extern from "../src/phredgenotypelikelihoods.h":
	cdef cppclass PhredGenotypeLikelihoods:
		PhredGenotypeLikelihoods(vector[double], unsigned int, unsigned int) except +
		PhredGenotypeLikelihoods(PhredGenotypeLikelihoods) except +
		double get(Genotype) except +
		string toString() except +
		unsigned int get_ploidy() except +
		unsigned int get_nr_alleles() except +
		unsigned int size() except +
		vector[double] as_vector() except +
		void get_genotypes(vector[Genotype]&) except +


cdef extern from "../src/genotypedistribution.h":
	cdef cppclass GenotypeDistribution:
		GenotypeDistribution(double hom_ref_prob, double het_prob, double hom_alt_prob) except +
		double probabilityOf(unsigned int genotype) except +


cdef extern from "../src/genotyper.h":
	void compute_genotypes(ReadSet, vector[Genotype]* genotypes, vector[GenotypeDistribution]* genotype_likelihoods, vector[unsigned int]* positions)  except +


cdef extern from "../src/hapchat/hapchatcore.cpp":
	cdef cppclass HapChatCore:
		HapChatCore(ReadSet*)
		void get_super_reads(vector[ReadSet*]*)
		vector[bool]* get_optimal_partitioning()
		int get_length()
		int get_optimal_cost()
